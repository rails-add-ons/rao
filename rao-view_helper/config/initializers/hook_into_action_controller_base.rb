ActiveSupport.on_load(:action_controller) do
  ActionController::Base.send(:include, Rao::ViewHelper::ControllerConcern)
end
# Rails.application.config.to_prepare do
#   ActionController::Base.send(:include, Rao::ViewHelper::ControllerConcern)
# end