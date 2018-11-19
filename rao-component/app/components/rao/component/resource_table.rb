module Rao
  module Component
      class ResourceTable < Base
        include BooleanConcern

        attr_reader :resource

        def initialize(*args)
          super
          @rows           = {}
          @resource       = @options.delete(:resource)
          @resource_class = @resource.class
        end

        def row(name, options = {}, &block)
          options.reverse_merge!(render_as: :default)
          options.reverse_merge!(block: block) if block_given?
          @rows[name] = options
        end

        def id(options = {}, &block)
          row(:id, options, &block)
        end

        def timestamp(name, options = {}, &block)
          options.reverse_merge!(render_as: :timestamp, format: Rao::Component::Configuration.table_default_timestamp_format)
          row(name, options, &block)
        end

        def timestamps(options = {})
          timestamp(:created_at, options)
          timestamp(:updated_at, options)
        end

        def association(name, options = {}, &block)
          options.reverse_merge!(render_as: :association)
          row(name, options, &block)
        end

        private

        def view_locals
          {
            rows:           @rows,
            resource:       @resource,
            resource_class: @resource_class
          }
        end
      end
    end
  end