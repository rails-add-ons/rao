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
end
