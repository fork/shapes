module Shapes
  module Primitives
    class Integer < Shapes::Primitive
      attr_accessor :value
      def initialize(options = {})
        @value = (options[:value] || 0).to_i
        super
      end

      def node_attributes
        {'value' => value.to_s}.merge(super)
      end

      def read_from_node
        @value = @xml_node['value'].to_i
        super
      end

      def update_attributes(params)
        @value = params[:value].to_i
        super
      end
    end
  end
end
