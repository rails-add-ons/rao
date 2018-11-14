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
      @collection.destroy_all

      respond_with @collection, location: after_destroy_many_location, notice: t('.success')
    end

    private

    def after_destroy_many_location
      collection_path
    end
  end
end