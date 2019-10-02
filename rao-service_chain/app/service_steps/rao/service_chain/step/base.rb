module Rao
	module ServiceChain
		module Step
			class Base
				attr_accessor :service, :service_name, :label, :chain

				def initialize(options = {})
					@service = options.delete(:service)
					@chain = options.delete(:chain)
					@completed_if = options.delete(:completed_if)
					@service_name = @service.try(:name)
					@label = service.try(:model_name).try(:human)
				end

				def url(context = nil)
					return nil if context.nil?
					@url ||= context.url_for([:new, @service, only_path: true])
				end

				def completed?
					return nil unless @completed_if.respond_to?(:call)
					@chain.instance_exec(@service, &@completed_if)
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
			end
		end
	end
end
