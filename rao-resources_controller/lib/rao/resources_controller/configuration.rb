module Rao
  module ResourcesController
    module Configuration
      def configure
        yield self
      end

      mattr_accessor(:resources_controller_base_class_name) do
        "::ApplicationController"
      end

      mattr_accessor(:pagination_per_page_default) do
        25
      end

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
