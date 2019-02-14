module Rao
  module Query
    class FormBuilder < SimpleForm::FormBuilder
      def boolean(name, options = {})
        translated_label = translate_label_for_boolean(name)
        options.reverse_merge!(collection: [[I18n.t("rao.query.form_builder.yes"), 1], [I18n.t("rao.query.form_builder.no"), 0]], include_blank: true, label: translated_label)
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
        title ||= I18n.t('rao.query.form_builder.submit')
        super(title, options)
      end

      def reset(title = nil, options = {})
        title ||= I18n.t('rao.query.form_builder.reset')
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
        I18n.t("rao.query.form_builder.predicates.#{predicate}", attribute_name: translated_attribute_name)
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
        I18n.t("rao.query.form_builder.boolean_label", attribute_name: translated_attribute_name)
      end
    end
  end
end
