module Api
  class PostsController < Rao::Api::ResourcesController::Base
    def self.resource_class
      Post
    end
  end
end
