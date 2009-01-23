module DuckDescribe
  module Primitives
    class Enum < DuckDescribe::Primitive

      attr_accessor :value, :selected
      attr_reader :separator

      def initialize(options = {})
        @separator  = options[:separator] || ','
        @value      = options[:value] || ''
        @selected   = options[:selected] || @value.first || ''
        super
      end

      def node_attributes
        super.merge 'selected' => selected, 'separator' => separator, 'value' => value
      end

      def add_node_content
        options.collect { |value|
          xml_builder.tag! :option, {:value => value}
        }
      end

      def options
        values = @value.split Regexp.new(separator)
        values.each { |option| option.strip! }
      end

      def read_from_node
        @separator  = @xml_node['separator'] || ','
        @value      = @xml_node['value'] || ''
        @selected   = @xml_node['selected'] || ''
        super
      end

      def update_attributes(params)
        @separator  = params[:separator] || ','
        @value      = params[:value] || ''
        @selected   = params[:selected] || options.first || ''
        super
      end

     end
  end
end
