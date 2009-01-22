module DuckDescribe
  module Builder    
    class PrimitiveFromXml
      def build_object(node)
        primitive = "DuckDescribe::Primitives::#{node.name.camelize}".constantize.new
        primitive.xml_node = node
        primitive.read_from_node
        primitive.new_resource = false
        primitive
      end
    end
  end
end