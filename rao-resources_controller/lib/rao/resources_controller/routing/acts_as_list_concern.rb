module Rao
  module ResourcesController
    module Routing
      # Example:
      #
      #     Rails.application.routes.draw do
      #       resources :posts do
      #         acts_as_list
      #       end
      #     end
      #
      # This will give you:
      #
      #                    Prefix Verb URI Pattern
      #          reposition_post POST   /posts/:id/reposition(.:format)           posts#reposition
      #
      module ActsAsListConcern
        def acts_as_list
          post :reposition, on: :member
        end
      end
    end
  end
end
