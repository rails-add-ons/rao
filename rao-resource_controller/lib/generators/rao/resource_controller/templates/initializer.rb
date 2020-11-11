Rao::ResourceController.configure do |config|
  # Set the base controller for resource controllers.
  #
  # default: config.resource_controller_base_class_name = '::ApplicationController'
  #
  config.resource_controller_base_class_name = '::ApplicationController'

  # Configures how a label will be created for the resource.
  #
  # default: config.label_for_resource_proc = lambda do |resource|
  #            [:human, :title, :name, :to_s].each do |method_name|
  #              next unless resource.respond_to?(method_name)
  #              return resource.send(method_name)
  #            end
  #          end
  #
  config.label_for_resource_proc = lambda do |resource|
    [:human, :title, :name, :to_s].each do |method_name|
      next unless resource.respond_to?(method_name)
      return resource.send(method_name)
    end
  end
end
