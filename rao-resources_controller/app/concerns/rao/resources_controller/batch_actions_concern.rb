module Rao
  # Don't forget to add routes:
  #
  #     # config/routes.rb;
  #     resources :users do
  #       post :destroy_many, on: :collection
  #     end
  #
  module ResourcesController::BatchActionsConcern
    def destroy_many
      @collection = load_collection_scope.where(id: params[:ids])
      count = @collection.count
      @collection.destroy_all

      default_message = t('.success', **inflections.merge(count: count, raise: false))
      respond_with @collection,
        location: after_destroy_many_location,
        notice: t('rao.resources_controller.batch_actions_concern.destroy_many.success', **inflections.merge(count: count, default: default_message))
    end

    private

    def after_destroy_many_location
      collection_path
    end
  end
end