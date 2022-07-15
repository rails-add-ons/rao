require 'active_support/concern'
require 'active_support/core_ext/hash/reverse_merge'
require "rao/service/result/base"
require 'active_model'

module Rao
  module Service
    class Base
      if Rao::Service.active_job_present?
        require 'rao/service/base/active_job_concern'
        include ActiveJobConcern
      end

      require 'rao/service/base/i18n_concern'
      include I18nConcern

      require 'rao/service/base/autosave_concern'
      include AutosaveConcern

      require 'rao/service/base/callbacks_concern'
      include CallbacksConcern

      require 'rao/service/base/messages_concern'
      include MessagesConcern

      require 'rao/service/base/errors_concern'
      include ErrorsConcern

      require 'rao/service/base/result_concern'
      include ResultConcern

      include ActiveModel::Model
      extend ActiveModel::Naming

      def self.attr_accessor(*args)
        super
        add_attribute_names(*args)
      end

      def self.attr_reader(*args)
        super
        add_attribute_names(*args)
      end

      def self.add_attribute_names(*args)
        args.each do |attr_name|
          attribute_names << attr_name
        end
      end

      def self.attribute_names
        (@attr_names ||= [])
      end

      def self.call(*args)
        new(*args).perform
      end

      def initialize(attributes = {}, options = {}, &block)
        @options    = options
        @block      = block
        @attributes = {}
        set_attributes(attributes)
        initialize_result
        initialize_errors
        initialize_messages
        after_initialize
      end

      private

      module Attributes
        def set_attributes(attributes)
          attributes.each do |key, value|
            send("#{key}=", value)
          end
        end

        def attributes
          self.class.attribute_names.each_with_object({}) do |attr, m|
            m[attr] = send(attr)
          end
        end
      end

      include Attributes
    end
  end
end
