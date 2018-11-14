module Rao
  module ResourcesController::AwesomeNestedSetConcern
    extend ActiveSupport::Concern

    def reposition
      @resource = load_resource
      @dropped_resource = resource_class.find(params[:dropped_id])
      @dropped_resource.move_to_right_of(@resource)

      label_methods = [:human, :name, :email, :to_s]

      target_resource_label = nil
      label_methods.each do |method_name|
        if @resource.respond_to?(method_name)
          target_resource_label = @resource.send(method_name)
          break
        end
      end

      inserted_resource_label = nil
      label_methods.each do |method_name|
        if @dropped_resource.respond_to?(method_name)
          inserted_resource_label = @dropped_resource.send(method_name)
          break
        end
      end

      redirect_to collection_path, notice: I18n.t("awesome_nested_set.flash.actions.reposition.notice", target_resource: target_resource_label, inserted_resource: inserted_resource_label)
    end
  end
end
