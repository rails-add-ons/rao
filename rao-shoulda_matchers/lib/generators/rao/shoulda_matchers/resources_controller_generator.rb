module Rao
  module ShouldaMatchers
    # This will generate specs for create, read, update, delete and list.
    # 
    # Example:
    # 
    #     rails g rao:shoulda_matchers:resources_controller --uri /de/backend/uploads
    #       create  spec/features/de/backend/uploads_feature_spec.rb
    #
    # If your resource class does not match the last part of your url (i.e.
    # /de/posts would guess the resource class to Post) you can specify the resource
    # name like this:
    #
    #     rails g rao:shoulda_matchers:resources_controller --uri="/de/posts" --resource_class="Blog::Post"
    #       create  spec/features/de/posts_feature_spec.rb
    #
    class ResourcesControllerGenerator < Rails::Generators::Base
      desc 'Generates CRUDL specs for REST resources'

      source_root File.expand_path('../templates', __FILE__)
 
      class_option :uri, type: :string, required: true
      class_option :resource_class, type: :string

      def uri
        @uri ||= options['uri']
      end

      def edit_form_dom_selector
        ".edit_#{resource_class.demodulize.underscore}"
      end

      def new_form_dom_selector
        "#new_#{resource_class.demodulize.underscore}"
      end

      def resource_class
        @resource_class ||= options['resource_class'] || @uri.split('/').last.camelize.singularize
      end

      def factory_name
        underscored_resource_class
      end

      def underscored_resource_class
        @undescored_resource_class ||= resource_class.underscore.gsub('/', '_')
      end

      def generate_spec
        template 'resources_controller_spec.rb', "spec/features#{uri}_feature_spec.rb"
      end
    end
  end
end