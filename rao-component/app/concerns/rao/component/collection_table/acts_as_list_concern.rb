module Rao
  module Component
    # Usage:
    #
    #     # app/models/gallery.rb
    #     class Picture < ActiveRecord::Base
    #       has_many :pictures, -> { order(position: :asc) }
    #       # ...
    #     end
    #
    #     # app/models/picture.rb
    #     class Picture < ActiveRecord::Base
    #       acts_as_list scope: :gallery
    #       # ...
    #     end
    #
    #     # app/galleries/index.html.haml
    #     = collection_table(collection: @pictures) do |table|
    #       = table.acts_as_list_actions scope: :gallery_id
    #
    # You will have to add a repositioning route to your resource:
    #
    #     # config/routes.rb:
    #     Rails.application.routes do
    #       resources :picture do
    #         post :reposition, on: :member
    #       end
    #       # ...
    #     end
    #
    # Additionally you will need a controller action to handle the reponsitioning.
    # Include Rao::ResourcesController::ActsAsListConcern from rao-resource_controller
    # if you don't want to implement it yourself:
    #
    #     # app/controllers/pictures_controller.rb
    #     class PicturesController < ApplicationController
    #       include Rao::ResourcesController::ActsAsListConcern
    #       # ...
    #     end
    #
    module CollectionTable::ActsAsListConcern
      extend ActiveSupport::Concern

      def acts_as_list_actions(options = {}, &block)
        options.reverse_merge!(render_as: :acts_as_list, title: t('.column_titles.acts_as_list'), scope: nil)

        scope = options.delete(:scope)
        scope = "#{scope}_id".intern if scope.is_a?(Symbol) && scope.to_s !~ /_id$/

        options.merge(scope: scope)

        column(:acts_as_list_actions, options, &block)
      end
    end
  end
end