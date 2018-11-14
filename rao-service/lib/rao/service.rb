require "rao/service/configuration"
require "rao/service/version"

module Rao
  module Service
    extend Configuration
    
    class_eval do
      def self.rails_present?
        # Gem.loaded_specs["rails"].present?
        Object.const_defined?('::Rails')
      end
    end
  end
end

require "rao/service/engine" if Object.const_defined?('::Rails')
require "rao/service/base"