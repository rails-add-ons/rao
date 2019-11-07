module Rao
  module Service
    module Base::ActiveJobConcern
      extend ActiveSupport::Concern

      class_methods do
        def call_later(attributes = {}, options = {})
          Rao::Service::Job.perform_later(self.name, attributes, options)
        end

        def call_later!(attributes = {}, options = {})
          call_later(attributes, options.merge(autosave: true))
        end
      end
    end
  end
end
