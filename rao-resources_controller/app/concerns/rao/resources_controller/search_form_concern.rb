module Rao
  module ResourcesController::SearchFormConcern
    extend ActiveSupport::Concern

    included do
      helper Rao::ResourcesController::SearchFormHelper
    end
  end
end