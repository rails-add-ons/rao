module Rao
  module Component
    # Example:
    #
    #     = resource_table(resource: @post) do |t|
    #       = t.id
    #       = t.row :title
    #       = t.row :body
    #       = t.boolean :visible
    #       = t.timestamps format: :short
    #
    class ResourceTable < Base
      include BooleanConcern

      SIZE_MAP = {
        default:    nil,
        small:      :sm,
        extrasmall: :xs
      }
      def size
        SIZE_MAP[@options[:size] || :default]
      end

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
          rows:             @rows,
          resource:         @resource,
          resource_class:   @resource_class,
          table_css_classes: table_css_classes
        }
      end

      def table_css_classes
        classes = ['table', 'resource-table', @resource_class.name.underscore.gsub('/', '-')]
        classes << 'table-bordered'   if bordered?
        classes << 'table-hover'      if hover?
        classes << 'table-inverse'    if inverse?
        classes << 'table-striped'    if striped?
        classes << 'table-responsive' if responsive?
        classes << "table-#{size}"    if size.present?
        classes
      end

      def striped?
        !!@options[:striped]
      end

      def responsive?
        !!@options[:responsive]
      end

      def inverse?
        !!@options[:inverse]
      end

      def bordered?
        !!@options[:bordered]
      end

      def hover?
        !!@options[:hover]
      end
    end
  end
end