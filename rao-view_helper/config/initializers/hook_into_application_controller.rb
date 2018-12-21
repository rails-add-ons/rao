Rails.application.config.to_prepare do
  ActionController::Base.send(:include, Rao::ViewHelper::ControllerConcern)
end