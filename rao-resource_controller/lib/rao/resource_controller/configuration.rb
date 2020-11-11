module Rao
  module ResourceController
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:resource_controller_base_class_name) { "::ApplicationController" }

      mattr_accessor(:label_for_resource_proc) do
        lambda do |resource|
          [:human, :title, :name, :to_s].each do |method_name|
            next unless resource.respond_to?(method_name)
            return resource.send(method_name)
          end
        end
      end
    end
  end
end