module Rao
  module Component
    # Example:
    #
    #     = collection_table(collection: @posts, resource_class: Post) do |t|
    #       = t.column :id, sort: true
    #       = t.column :title
    #       = t.column :body
    #       = t.boolean :visible
    #       = t.timestamps format: :short
    #
    class CollectionTable < Base
      include AwesomeNestedSetConcern
      include ActsAsPublishedConcern
      include ActsAsListConcern
      include BatchActionsConcern
      include BooleanConcern
      include EmailConcern
      include DateConcern

      attr_reader :collection

      SIZE_MAP = {
        default:    nil,
        small:      :sm,
        extrasmall: :xs
      }

      def initialize(*args)
        super
        @options.reverse_merge!(header: true)

        @columns        = {}
        @collection     = @options.delete(:collection)
        @resource_class = @options.delete(:resource_class) || @collection.first.class
      end

      def column(name, options = {}, &block)
        options.reverse_merge!(render_as: :default)
        options.reverse_merge!(block: block) if block_given?
        @columns[name] = options
      end

      def id(options = {}, &block)
        column(:id, options, &block)
      end

      def timestamp(name, options = {}, &block)
        options.reverse_merge!(render_as: :timestamp, format: Rao::Component::Configuration.table_default_timestamp_format)
        column(name, options, &block)
      end

      def timestamps(options = {})
        timestamp(:created_at, options)
        timestamp(:updated_at, options)
      end

      # Example:
      #
      #     = table.association :category, sortable: true, label_method: :name, link_to: ->(r) { url_for(r.category) }
      #
      def association(name, options = {}, &block)
        options.reverse_merge!(render_as: :association)
        column(name, options, &block)
      end

      private

      def table
        self
      end

      def view_locals
        {
          columns:           @columns,
          collection:        @collection,
          resource_class:    @resource_class,
          table_css_classes: table_css_classes,
          show_header:       show_header
        }
      end

      def show_header
        !!@options[:header]
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

      def size
        SIZE_MAP[@options[:size] || :default]
      end

      def table_css_classes
        return @options[:table_html] if @options.has_key?(:table_html)
        classes = ['table', 'collection-table', @resource_class.name.underscore.pluralize.gsub('/', '-')]
        classes << 'table-bordered'   if bordered?
        classes << 'table-hover'      if hover?
        classes << 'table-inverse'    if inverse?
        classes << 'table-striped'    if striped?
        classes << 'table-responsive' if responsive?
        classes << "table-#{size}"    if size.present?
        classes
      end

      def t(key, options = {})
        I18n.t("#{self.class.name.underscore.gsub('/', '.')}#{key}", options)
      end
    end
  end
end