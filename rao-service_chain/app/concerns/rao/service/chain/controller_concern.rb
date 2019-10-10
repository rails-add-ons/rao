module Rao
  module Service
    module Chain
      # Usage:
      #
      #     # app/service_chains/checkout_service_chain.rb
      #     class CheckoutServiceChain < Rao::Service::Chain::Base
      #       def steps
      #         [
      #           wrap(CartService, completed_if: ->(service) { service.new.valid? }),
      #           wrap(PaymentOptionsService, completed_if: ->(service) { service.new.valid? }),
      #           wrap(DeliveryAddressService, completed_if: ->(service) { service.new.valid? }),
      #           wrap(ConfirmationService, completed_if: ->(service) { service.new.valid? }),
      #           wrap(ResultService, completed_if: ->(service) { service.new.valid? }),
      #         ]
      #       end
      #     end
      #
      #     # app/controllers/checkout_services_controller/base.rb
      #     module CheckoutServicesController
      #       class Base < Rao::ServiceController::Base
      #         include Rao::Service::Chain::ControllerConcern
      #
      #         def self.service_chain_class
      #           CheckoutServiceChain
      #         end
      #
      #         private
      #
      #         def after_sucess_location
      #           next_step_url
      #         end
      #       end
      #     end
      #
      module ControllerConcern
        extend ActiveSupport::Concern

        included do
          before_action :load_service_chain
          helper_method :service_chain
        end

        class_methods do
          def service_chain_class
            raise "Child class responsibilty"
          end
        end
        
        private

        def service_chain
          @service_chain
        end

        def service_chain_class
          self.class.service_chain_class
        end

        def load_service_chain
          @service_chain = service_chain_class.new(actual_step: self.service_class)
        end

        def next_step_url
          @service_chain.next_step_url(context: self)
        end
      end
    end
  end
end