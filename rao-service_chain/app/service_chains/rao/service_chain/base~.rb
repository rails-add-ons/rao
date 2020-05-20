module Rao
  module ServiceChain
      class Base
      attr_accessor :steps
      attr_accessor :actual_step

      def initialize(options = {})
        options.each do |key, value|
          self.send("#{key}=", value)
        end
        if @actual_step.present?
          actual_service = unwrap(@actual_step)
          @actual_step = find_step_by_service(actual_service)
        end
      end

      def wrap_actual_step!
        @actual_step = wrap(@actual_step)
      end

      def steps=(steps)
        @steps = steps.map { |s| wrap(s) }
      end

      def steps
        raise "Child class responsiblity"
      end

      def step_index(step)
        self.steps.map(&:service).index(step.try(:service))
      end
      
      def service_index(service)
        self.steps.map(&:service).index(service)
      end

      def find_step_by_service(service)
        self.steps[(service_index(service))]
      end

      def actual_step_index
        self.steps.map(&:service).index(self.actual_step.try(:service))
      end

      def step_count
        self.steps.size
      end

      def previous_step_index
        self.steps.map(&:service).index(self.previous_step.try(:service))
      end

      def next_step_index
        self.steps.map(&:service).index(self.next_step.try(:service))
      end

      def previous_step
        return nil if self.actual_step_index.nil?
        return nil if self.actual_step_index - 1 < 0
        self.steps[self.actual_step_index - 1]
      end

      def previous_steps
        return [] if self.actual_step_index.nil?
        return [] if self.actual_step_index == 0
        self.steps[0..(self.actual_step_index - 1)]
      end

      def next_step
        if self.actual_step.try(:next_step).respond_to?(:call)
          find_step_by_service(self.actual_step.next_step.call(self.actual_step))
        else
          return nil if self.actual_step_index.nil?
          return nil if self.actual_step_index + 1 >= self.step_count
          self.steps[self.actual_step_index + 1]
        end
      end

      def next_steps
        return [] if self.actual_step_index.nil?
        self.steps[(self.actual_step_index + 1)..-1]
      end

      def next_step?
        !!next_step
      end

      def previous_step?
        !!previous_step
      end

      def next_step_url(options = {})
        context = options.delete(:context)
        self.next_step.url(context)
      end

      def steps_with_urls(context)
        self.steps.map { |s| s.url(context); s }
      end

      def to_hash(context = nil)
        {
          actual_step: self.actual_step.to_hash(context),
          steps: self.steps.map { |s| s.to_hash(context) }
        }
      end

      def completed_steps
        self.steps.collect { |s| s.completed? ? s : nil }.compact
      end

      def pending_steps
        self.steps.collect { |s| s.pending? ? s : nil }.compact
      end

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

      private

      def wrap(service, options = {})
        if service.is_a?(wrapper_base_class)
           service
        else
          wrapper_base_class.new(options.merge(service: service, chain: self))
        end
      end

      def unwrap(step_or_service)
        if step_or_service.is_a?(wrapper_base_class)
          step_or_service.service
        else
          step_or_service
        end
      end

      def wrapper_base_class
        Rao::ServiceChain::Step::Base
      end
    end
  end
end
