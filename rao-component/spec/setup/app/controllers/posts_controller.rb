class PostsController < ApplicationController
  include Rao::ResourcesController::Plural::ResourcesConcern
  include Rao::ResourcesController::Plural::RestActionsConcern
  include Rao::ResourcesController::Plural::RestUrlsConcern
  include Rao::ResourcesController::ActsAsListConcern
  include Rao::ResourcesController::ActsAsPublishedConcern

  def self.resource_class
    Post
  end

  private

  def after_publish_toggle_location
    { action: :index }
  end
end
