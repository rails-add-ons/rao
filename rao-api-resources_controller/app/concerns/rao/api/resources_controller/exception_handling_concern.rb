module Rao
  module Api
    module ResourcesController::ExceptionHandlingConcern
      extend ActiveSupport::Concern

      included do
        rescue_from Exception do |exception|
          handle_exception(exception)
        end

        rescue_from ActiveRecord::RecordNotFound do |exception|
          handle_404(exception)
        end
      end

      private

      def handle_404(exception = nil)
        respond_to do |format|
          format.json { render json: { error: (exception.try(:message) || 'Not found') }, status: 404 }
        end
      end

      def handle_exception(exception)
        if Rails.env.development? || Rails.env.test?
          error = { message: exception.message }

          error[:application_trace] = Rails.backtrace_cleaner.clean(exception.backtrace)
          error[:full_trace] = exception.backtrace

          respond_to do |format|
            format.json { render json: error, status: 500 }
          end
        else
          respond_to do |format|
            format.json { render json: { error: 'Internal server error.' }, status: 500 }
          end
        end
      end
    end
  end
end