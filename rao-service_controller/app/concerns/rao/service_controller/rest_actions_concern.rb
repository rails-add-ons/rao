module Rao
  module ServiceController::RestActionsConcern
    extend ActiveSupport::Concern

    included do
      unless respond_to?(:respond_to)
        raise "undefined method `respond_to' for #{self.name}: If you are running Rails > 4 you may need to add the responders gem to your Gemfile."
      end

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
        before_respond_on_success if respond_to?(:before_respond_on_success, true)
        if respond_to?(:after_success_location, true) && after_success_location.present?
          flash.notice = success_message if success_message.present?
          redirect_to(after_success_location)
        else
          flash.now[:notice] = success_message if success_message.present?
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