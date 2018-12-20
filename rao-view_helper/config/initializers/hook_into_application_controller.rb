Rails.application.config.after_initialize do
  ActionController::Base.send(:include, Rao::ViewHelper::ControllerConcern)
end