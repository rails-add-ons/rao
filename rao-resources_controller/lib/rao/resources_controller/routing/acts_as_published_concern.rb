module Rao
  module ResourcesController
    module Routing
      # Example:
      #
      #     Rails.application.routes.draw do
      #       resources :posts do
      #         acts_as_published
      #       end
      #     end
      #
      # This will give you:
      #
      #                    Prefix Verb URI Pattern
      #     toggle_published_post POST   /posts/:id/toggle_published(.:format)      posts#toggle_published
      #
      module ActsAsPublishedConcern
        def acts_as_published
          post :toggle_published, on: :member
        end
      end
    end
  end
end
