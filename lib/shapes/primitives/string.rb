module Shapes
  module Primitives
    class String < Shapes::Primitive

      attr_accessor :value

      def initialize(options = {})
        @value = options[:value].to_s
        super
      end

      def attributes
        {:value => @value}
      end

      def build_node_content
        xml_builder.cdata @value.strip
      end

      def read_from_node
        @value = @xml_node.content
        super
      end

      def update_attributes(params)
        @value = params[:value].to_s
        super
      end

    end
  end
end
