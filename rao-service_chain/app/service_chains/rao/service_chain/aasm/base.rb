
module Rao
  module ServiceChain
    module Aasm
      class Base
        include ::AASM

        def initialize(options = {})
          options.each do |k,v|
            send("#{k}=", v)
          end
        end

        module ServiceConcern
          extend ActiveSupport::Concern

          class_methods do
            def service_module_name
              nil
            end
          end

          def service_class_to_state(service_class)
            service_class.name.demodulize.underscore.to_sym
          end

          def state_to_service_class(state)
            "#{self.class.service_module_name}#{state.to_s.camelize}".constantize
          end
        end

        include ServiceConcern

        module StepConcern
          extend ActiveSupport::Concern

          def actual_step=(service_class)
            aasm.current_state = service_class_to_state(service_class)
          end

          def actual_step
            return nil if %i(started finished).include?(aasm.current_state)
            wrap(
              state_to_service_class(aasm.current_state),
              completed_if: aasm.states.find { |s| s.name == aasm.current_state }.options[:completed_if],
              router: aasm.states.find { |s| s.name == aasm.current_state }.options[:router],
              url: aasm.states.find { |s| s.name == aasm.current_state }.options[:url],
            )
          end

          def previous_steps 
            current_state = aasm.current_state
            o = []
            i = 0
            while(i < 1000) do
              previous_event = aasm.events.select{ |e| e.name == :previous }.first
              return [] unless previous_event.respond_to?(:transitions)
              targets = previous_event.transitions.select{ |t|
              # targets = aasm.events(permitted: true).select{ |e| e.name == :next }.first.transitions.select{ |t|
                t.from == current_state
              }.select{ |t|
                guards = t.instance_variable_get(:@guards)
                if guards.empty?
                  true
                else
                  guards.map { |g| send(g) }.all?
                end
              }.map { |t|
                {
                  t.to => {
                    display: (t.options[:display].presence || -> { true }),
                    completed_if: aasm.states.find { |s| s.name == t.to }.options[:completed_if],
                    router: aasm.states.find { |s| s.name == t.to }.options[:router],
                    url: aasm.states.find { |s| s.name == t.to }.options[:url],
                  } 
                }
              }
              break if targets.empty? || %i(started finished).include?(targets.first.first[0])
              o << wrap(state_to_service_class(targets.first.first[0]), targets.first.first[1])
              current_state = targets.first.first[0]
              i = i + 1
            end
            o.reverse.compact
          end

          def next_steps
            current_state = aasm.current_state
            o = []
            i = 0
            while(i < 1000) do
              previous_event = aasm.events.select{ |e| e.name == :next }.first
              return [] unless previous_event.respond_to?(:transitions)
              targets = previous_event.transitions.select{ |t|
              # targets = aasm.events(permitted: true).select{ |e| e.name == :next }.first.transitions.select{ |t|
                t.from == current_state
              }.select{ |t|
                guards = t.instance_variable_get(:@guards)
                if guards.empty?
                  true
                else
                  guards.map { |g| send(g) }.all?
                end
              }.map { |t|
                {
                  t.to => {
                    display: (t.options[:display].presence || -> { true }),
                    completed_if: aasm.states.find { |s| s.name == t.to }.options[:completed_if],
                    router: aasm.states.find { |s| s.name == t.to }.options[:router],
                    url: aasm.states.find { |s| s.name == t.to }.options[:url],
                  } 
                }
              }
              break if targets.empty? || %i(started finished).include?(targets.first.first[0])
              o << wrap(state_to_service_class(targets.first.first[0]), targets.first.first[1])
              current_state = targets.first.first[0]
              i = i + 1
            end
            o.compact
          end

          def steps
            # aasm.states.map(&:name).map { |s| wrap(state_to_service_class(s)) }
            o = []

            #walk backwards
            # current_state = aasm.current_state
            # i = 0
            # while(i < 1000) do
            #   targets = aasm.events.select{ |e| e.name == :previous }.first.transitions.select{ |t|
            #   # targets = aasm.events(permitted: true).select{ |e| e.name == :previous }.first.transitions.select{ |t|
            #     t.from == current_state
            #   }.select{ |t|
            #     guards = t.instance_variable_get(:@guards)
            #     if guards.empty?
            #       true
            #     else
            #       guards.map { |g| send(g) }.all?
            #     end
            #   }.map { |t| t.to }
            #   break if targets.empty?
            #   o << wrap(state_to_service_class(targets.first))
            #   current_state = targets.first
            #   i = i + 1
            # end

            # o.reverse!

            o << self.previous_steps

            # add actual state
            o << self.actual_step unless self.actual_step.nil?
            # o << wrap(state_to_service_class(aasm.current_state))

            # walk forward
            o << self.next_steps
            # current_state = aasm.current_state
            # i = 0
            # while(i < 1000) do
            #   targets = aasm.events.select{ |e| e.name == :next }.first.transitions.select{ |t|
            #   # targets = aasm.events(permitted: true).select{ |e| e.name == :next }.first.transitions.select{ |t|
            #     t.from == current_state
            #   }.select{ |t|
            #     guards = t.instance_variable_get(:@guards)
            #     if guards.empty?
            #       true
            #     else
            #       guards.map { |g| send(g) }.all?
            #     end
            #   }.map { |t| {t.to => { display: (t.options[:display].presence || -> { true }) } } }
            #   break if targets.empty?
            #   o << wrap(state_to_service_class(targets.first.first[0]), targets.first.first[1])
            #   current_state = targets.first.first[0]
            #   i = i + 1
            # end
            o.flatten
          end

          def step_count
            steps.size
          end

          def completed_steps
            self.steps.collect { |s| s.completed? ? s : nil }.compact
          end
    
          def pending_steps
            self.steps.collect { |s| s.pending? ? s : nil }.compact
          end

          private

          def wrap(service, options = {})
            wrapper_class = Rao::ServiceChain::Step::Base
            if service.is_a?(wrapper_class)
                service
            else
              wrapper_class.new(options.merge(service: service, chain: self))
            end
          end
        end

        include StepConcern

        module StepOrderConcern
          extend ActiveSupport::Concern

          def before_actual?(step)
            return false if self.actual_step.nil?
            return false if (si = step_index(wrap(step))).nil?
            self.actual_step_index > si
          end
    
          def after_actual?(step)
            return false if self.actual_step.nil?
            return false if (si = step_index(wrap(step))).nil?
            self.actual_step_index < si
          end

          def step_index(step)
            self.steps.map(&:service).index(step.try(:service))
          end

          def actual_step_index
            self.steps.map(&:service).index(self.actual_step.try(:service))
          end

          def next_step
            self.next_steps.first
            # return nil if self.actual_step_index.nil?
            # return nil if self.actual_step_index + 1 >= self.step_count
            # self.steps[self.actual_step_index + 1]
          end

          def previous_step
            self.previous_steps.last
            # return nil if self.actual_step_index.nil?
            # return nil if self.actual_step_index - 1 < 0
            # self.steps[self.actual_step_index - 1]
          end

          def next_step_url(options = {})
            context = options.delete(:context)
            self.next_step.url(context)
          end
        end

        include StepOrderConcern

        module SerializationConcern
          extend ActiveSupport::Concern

          def to_hash(context = nil)
            {
              actual_step: self.actual_step.to_hash(context),
              steps: self.steps.map { |s| s.to_hash(context) }
            }
          end
        end

        include SerializationConcern
      end
    end
  end
end
