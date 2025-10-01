class PostsController < ApplicationController
  include Rao::ResourcesController::ResourceInflectionsConcern
  include Rao::ResourcesController::DefaultViewsConcern
  include Rao::ResourcesController::Plural::RestUrlsConcern
  include Rao::ResourcesController::Plural::ResourcesConcern
  include Rao::ResourcesController::Plural::RestActionsConcern
  include Rao::ResourcesController::Plural::AvailableRestActionsConcern

  def self.resource_class
    Post
  end

  private

  def resource_params
    params.require(:post).permit(:title, :body)
  end
  end