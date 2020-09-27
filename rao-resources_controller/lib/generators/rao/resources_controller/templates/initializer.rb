Rao::ResourcesController.configure do |config|
  # Set the base controller for resources controllers.
  #
  # default: config.resources_controller_base_class_name = '::ApplicationController'
  #
  config.resources_controller_base_class_name = '::ApplicationController'

  # Set the pagination item count per page.
  #
  # Works for kaminari and will_paginate.
  #
  # default: config.pagination_per_page_default = 25
  #
  config.pagination_per_page_default = 25

  # Configures how a label will be created for resources.
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
