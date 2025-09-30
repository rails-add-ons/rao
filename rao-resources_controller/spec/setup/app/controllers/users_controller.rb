class UsersController < ApplicationController
  include Rao::ResourcesController::ResourceInflectionsConcern
  include Rao::ResourcesController::DefaultViewsConcern
  include Rao::ResourcesController::Singular::RestUrlsConcern
  include Rao::ResourcesController::Singular::ResourcesConcern
  include Rao::ResourcesController::Singular::RestActionsConcern

  def self.resource_class
    User
  end

  private

  def load_resource
    @resource = User.first
  end

  def resource_params
    params.require(:user).permit(:name, :email, :bio)
  end
  end