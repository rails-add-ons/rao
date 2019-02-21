module Api
  class PostsController < Rao::Api::ResourcesController::Base
    # Here we specify the model class this controller is for.
    def self.resource_class
      Post
    end
  end
end