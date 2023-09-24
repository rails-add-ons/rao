module Rao
  module ResourcesController
    module AasmConcern
      extend ActiveSupport::Concern

      included do
        before_action :load_resource_for_trigger_event, only: [:trigger_event]
      end

      def trigger_event
        begin
          result = @resource.aasm(permitted_params_for_trigger_event[:machine_name].to_sym).fire!(permitted_params_for_trigger_event[:event_name].to_sym)
        rescue ActiveRecord::RecordInvalid => e
          result = false
        end

        if result
          flash[:notice] = t(
            'rao.resources_controller.aasm_concern.trigger_event.success',
            event: permitted_params_for_trigger_event[:event_name],
            state: @resource.aasm(permitted_params_for_trigger_event[:machine_name].to_sym).current_state
          )
        else
          flash[:danger] = t(
            'rao.resources_controller.aasm_concern.trigger_event.failure',
            event: permitted_params_for_trigger_event[:event_name],
            errors: @resource.errors.full_messages.to_sentence
          )
        end

        redirect_back(fallback_location: root_path)
      end

      private

      def permitted_params_for_trigger_event
        params.permit!
      end

      def load_resource_for_trigger_event
        load_resource
      end
    end
  end
end
