module Rao
  module Service
    # Provides ActiveJob integration for service objects to enable background processing.
    #
    # This concern adds the ability to execute service objects asynchronously in the
    # background using ActiveJob. It provides convenience class methods to enqueue
    # services for later execution, with support for both regular and autosave modes.
    #
    # The concern automatically integrates with Rao::Service::Job to handle the
    # actual job execution, passing the service class name, attributes, and options.
    #
    # @example Basic background execution
    #   class SendEmailService < Rao::Service::Base
    #     attr_accessor :recipient, :subject, :body
    #
    #     def perform
    #       # Email sending logic
    #       Mailer.send_email(recipient, subject, body).deliver_now
    #       add_message("Email sent successfully")
    #     end
    #   end
    #
    #   # Enqueue for background execution
    #   SendEmailService.call_later(
    #     recipient: "user@example.com",
    #     subject: "Welcome!",
    #     body: "Welcome to our service!"
    #   )
    #
    # @example With autosave enabled
    #   class ProcessDataService < Rao::Service::Base
    #     attr_accessor :data_set_id
    #
    #     def perform
    #       # Data processing logic
    #       data_set = DataSet.find(data_set_id)
    #       data_set.process!
    #       result.data_set = data_set
    #     end
    #   end
    #
    #   # Enqueue with autosave (automatically saves associated models)
    #   ProcessDataService.call_later!(
    #     data_set_id: 123,
    #     autosave: true
    #   )
    #
    # @note This concern is only included when ActiveJob is present in the application
    # @see Rao::Service::Job The job class that handles background execution
    module Base::ActiveJobConcern
      extend ActiveSupport::Concern

      class_methods do
        # Enqueues the service for background execution using ActiveJob.
        #
        # This method creates a background job that will execute the service
        # asynchronously. The service will be instantiated with the provided
        # attributes and options when the job runs.
        #
        # @param attributes [Hash] Attributes to pass to the service constructor
        # @param options [Hash] Additional options for job execution
        # @return [ActiveJob::Base] The enqueued job instance
        #
        # @example Basic usage
        #   SendEmailService.call_later(
        #     recipient: "user@example.com",
        #     subject: "Welcome!"
        #   )
        #
        # @example With job options
        #   ProcessDataService.call_later(
        #     { data_id: 123 },
        #     { wait: 5.minutes, queue: 'high_priority' }
        #   )
        def call_later(attributes = {}, options = {})
          Rao::Service::Job.perform_later(self.name, attributes, options)
        end

        # Enqueues the service for background execution with autosave enabled.
        #
        # This method is a convenience wrapper around #call_later that automatically
        # enables the autosave option. When autosave is enabled, associated models
        # will be automatically saved after the service completes successfully.
        #
        # @param attributes [Hash] Attributes to pass to the service constructor
        # @param options [Hash] Additional options for job execution (autosave is forced to true)
        # @return [ActiveJob::Base] The enqueued job instance
        #
        # @example
        #   ProcessDataService.call_later!(
        #     data_set_id: 123,
        #     wait: 1.hour
        #   )
        #   # Equivalent to:
        #   # ProcessDataService.call_later({ data_set_id: 123 }, { wait: 1.hour, autosave: true })
        def call_later!(attributes = {}, options = {})
          call_later(attributes, options.merge(autosave: true))
        end
      end
    end
  end
end
