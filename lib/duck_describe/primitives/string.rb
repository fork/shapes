module DuckDescribe  
  module Primitives
    class String < DuckDescribe::Primitive
      attr_accessor :value
      def initialize(options = {})
        @value = options[:value] ? options[:value].strip : ''
        super
      end

      def add_node_content
        xml_builder.cdata! @value
      end

      def read_from_node
        @value = @xml_node.content
        super
      end
 
      def update_attributes(params)
        @value = params[:value].strip if params[:value]
        super
      end
     end
  end
end
