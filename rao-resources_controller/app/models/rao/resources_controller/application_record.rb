module Rao
  module ResourcesController
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
