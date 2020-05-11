module Rao
  module ServiceChain
    module Step
      class Base
        attr_accessor :service, :service_name, :label, :chain, :router

        def initialize(options = {})
          @service = options.delete(:service)
          @chain = options.delete(:chain)
          @completed_if = options.delete(:completed_if)
          @display = options.delete(:display) || ->() { true }
          @service_name = @service.try(:name)
          @label = service.try(:model_name).try(:human)
          @url = options.delete(:url)
          @router = options.delete(:router) || :main_app
        end

        def url(context = nil)
          return nil if context.nil?
          return context.instance_exec(@service, &@url) if @url.respond_to?(:call)
          @url ||= context.send(router).url_for([:new, @service, only_path: true])
        end

        def completed?
          return nil unless @completed_if.respond_to?(:call)
          @chain.instance_exec(@service, &@completed_if)
        end

        def render_as_completed?(options = {})
          render_previous_steps_as_pending = options.dig(:previous_steps, :render_as_pending)
          render_next_step_as_pending = options.dig(:next_steps, :render_as_pending)

          if @chain.before_actual?(self)
            if render_previous_steps_as_pending
              completed?
            else
              true
            end
          else
            if render_next_step_as_pending
              false
            else
              completed?
            end
          end
        end
        
        def pending?
          !completed?
        end

        def completion_status
          completed? ? :completed : :pending
        end

        def actual?
          return false if @chain.actual_step.nil?
          @chain.actual_step.service == @service
        end

        def to_hash(context = nil)
          {
            service: service,
            service_name: service.name,
            label: label,
            completed: completed?,
            pending: pending?,
            completion_status: completion_status,
            actual: actual?,
            url: url(context)
          }
        end

        def display?
          !!@display.call
        end
      end
    end
  end
end
