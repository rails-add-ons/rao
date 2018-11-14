Rao::ServiceController.configure do |config|
  # Set the base controller for service controllers.
  #
  # default: config.service_controller_base_class_name = '::ApplicationController'
  #
  config.service_controller_base_class_name = '::ApplicationController'
end
