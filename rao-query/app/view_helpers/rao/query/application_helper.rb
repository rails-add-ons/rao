module Rao
  module Query
    # First you have to add the helper and the query concern to your controller:
    #
    #     # app/controllers/application_controller.rb
    #     class ApplicationController < ActionController::Base
    #       include Rao::Query::Controller::QueryConcern
    #       view_helper Rao::Query::ApplicationHelper, as: :query_helper
    #       # ....
    #     end
    #
    class ApplicationHelper < ViewHelper::Base
      # Example:
      #
      #     # app/views/posts/index.html.haml
      #     = query_helper(self).form_for(@posts, url: posts_path, method: :get) do |f|
      #       = f.input :title_cont
      #       = f.input :body_cont
      #       = f.boolean :published_eq
      #       = f.submit nil, class: 'btn btn-primary'
      #       = f.reset  nil, class: 'btn btn-default'
      #
      #     # app/controllers/posts_controller.rb
      #     class ApplicationController < ActionController::Base
      #       def index
      #         @posts = with_conditions_from_query(Post).all
      #       end
      #
      # If you are using bootstrap you may want to display the form inline for a
      # more compact view:
      #
      #     = query_helper(self).form_for(collection, html: { class: 'form-inline' }) do |f|
      #
      def form_for(collection, options = {}, &block)
        handle_simple_form_missing unless c.respond_to?(:simple_form_for)
        wrapped_collection = SearchableCollection.new(collection, c.params[:q])
        c.simple_form_for(wrapped_collection, options.reverse_merge(as: :q, url: c.collection_path, method: :get, builder: SearchFormBuilder), &block)
      end

      class SearchFormBuilder < SimpleForm::FormBuilder
        def boolean(name, options = {})
          translated_label = translate_label_for_boolean(name)
          options.reverse_merge!(collection: [[I18n.t("search_form_builder.yes"), 1], [I18n.t("search_form_builder.no"), 0]], include_blank: true, label: translated_label)
          input name, options
        end

        def input(name, options = {})
          if association = options.delete(:association)
            translated_label = translate_label(name, association)
            input_name = "#{association}.#{name}"
          else
            translated_label = translate_label(name)
            input_name = name
          end
          super(input_name, options.reverse_merge(label: translated_label))
        end

        def submit(title = nil, options = {})
          title ||= I18n.t('search_form_builder.submit')
          super(title, options)
        end

        def reset(title = nil, options = {})
          title ||= I18n.t('search_form_builder.reset')
          link_html = options.delete(:link_html) || {}
          template.link_to(title, template.url_for(), link_html)
        end

        private

        def translate_label(name, association = nil)
          splitted_name = name.to_s.split('_')
          attribute_name = splitted_name[0..-2].join('_')
          predicate = splitted_name.last
          translated_attribute_name = if association.nil?
            klass_name = object.original_model_class_name
            klass_name.constantize.human_attribute_name(attribute_name)
          else
            klass_name = object.original_model_class.reflect_on_association(association).klass.name
            klass = klass_name.constantize
            "#{klass.model_name.human} #{klass.human_attribute_name(attribute_name)}"
          end
          I18n.t("search_form_builder.predicates.#{predicate}", attribute_name: translated_attribute_name)
        end

        def translate_label_for_boolean(name)
          splitted_name = name.to_s.split('_')
          attribute_name = splitted_name[0..-2].join('_')
          predicate = splitted_name.last
          if association.nil?
            klass_name = object.original_model_class_name
          else
            klass_name = object.original_model_class.reflect_on_association(association).klass
          end
          translated_attribute_name = klass_name.constantize.human_attribute_name(attribute_name)
          I18n.t("search_form_builder.boolean_label", attribute_name: translated_attribute_name)
        end
      end

      class SearchableCollection
        include ActiveModel::Model
        extend ActiveModel::Translation

        def method_missing(method, *args)
          if method.to_s.match(/(.+)_(gt|gt_or_eq|eq|not_eq|lt_or_eq|lt|null|not_null|cont)/)
            @query.send(:[], method)
          else
            super
          end
        end

        def initialize(collection, query)
          @collection = collection
          @query = query || {}
        end

        def original_model_class_name
          @collection.class.to_s.deconstantize
        end

        def original_model_class
          @collection.klass
        end
      end

      def handle_simple_form_missing
        raise "simple_form_for is not available. Please add simple_form to your Gemfile."
      end
    end
  end
end
