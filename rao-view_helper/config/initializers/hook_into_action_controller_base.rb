ActiveSupport.on_load(:action_controller) do
  ActionController::Base.send(:include, Rao::ViewHelper::ControllerConcern)
end
