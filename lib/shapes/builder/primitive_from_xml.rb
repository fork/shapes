module Shapes
  module Builder
    class PrimitiveFromXml
      def build_object(node)
        primitive = "Shapes::Primitives::#{node.name.camelize}".constantize.new
        primitive.xml_node = node
        primitive.read_from_node
        primitive
      end
    end
  end
end
