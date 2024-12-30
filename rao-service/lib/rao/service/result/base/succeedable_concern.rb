module Rao
  module Service
    module Result
      module Base::SucceedableConcern
        extend ActiveSupport::Concern

        def success?
          !failed?
        end

        alias_method :ok?, :success?

        def failed?
          @service.errors.any?
        end
      end
    end
  end
end
