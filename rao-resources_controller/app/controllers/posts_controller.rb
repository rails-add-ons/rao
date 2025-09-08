class PostsController < ApplicationController
  include Rao::ResourcesController::ResourceInflectionsConcern
  include Rao::ResourcesController::DefaultViewsConcern
  include Rao::ResourcesController::Plural::RestResourcesUrlsConcern
  include Rao::ResourcesController::Plural::ResourcesConcern
  include Rao::ResourcesController::Plural::RestActionsConcern

  def self.resource_class
    Post
  end

  private

  def resource_params
    params.require(:post).permit(:title, :content)
  end
end
