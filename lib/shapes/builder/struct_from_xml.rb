module Shapes
  module Builder
    class StructFromXml

      def build_object(node)
        struct = Shapes::Struct.new
        struct.xml_node = node
        struct.read_from_node
        struct.ident = node['ident'].to_s
        struct.description = node['description'].to_s
        struct
      end

    end
  end
end
