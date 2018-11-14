module Rao
  module ServiceController::RestActionsConcern
    extend ActiveSupport::Concern

    included do
      respond_to :html
      responders :flash

      if respond_to?(:before_action)
        before_action :initialize_service, only: [:new]
        before_action :initialize_service_for_create, only: [:create]
      else
        before_filter :initialize_service, only: [:new]
        before_filter :initialize_service_for_create, only: [:create]
      end
    end

    def new; end

    def create
      perform
    end

    private

    def perform
      @result = execute_service
      if @result.success?

        if respond_to?(:after_success_location, true) && after_success_location.present?
          redirect_to(after_success_location, notice: success_message)
        else
          flash.now[:success] = success_message
          render :create
        end
      else
        render :new
      end
    end


    def success_message
      t('flash.actions.perform.notice', resource_name: @service.class.model_name.human)
    end

    def execute_service
      @service.send(execute_method)
    end

    def execute_method
      :perform
    end

    def hashified_params
      if permitted_params.respond_to?(:to_h)
        permitted_params.to_h
      else
        permitted_params
      end
    end

    def initialize_service
      @service = service_class.new({}, service_options)
    end

    # Override this method in your child class to manipulate your service before
    # it performs.
    #
    # Example:
    #     # app/controller/import_services_controller.rb
    #     class ImportServices < ApplicationServicesController
    #       #...
    #       private
    #
    #       def initialize_service_for_create
    #         super
    #         @service.current_user_id = session['current_user_id']
    #       end
    #     end
    #
    def initialize_service_for_create
      @service = service_class.new(hashified_params, service_options)
    end

    def service_options
      default_options
    end

    def default_options
      { autosave: true }
    end

    def permitted_params
      raise "You have to implement permitted_params in #{self.class.name}."
    end
  end
end