Rails.application.routes.draw do
  mount RailsAddOnsService::Engine => "/rails_add_ons_service"
end
