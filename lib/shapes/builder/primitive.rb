module Shapes
  module Builder
    class Primitive

      attr_reader :data
      attr_accessor :builder_strategy, :resource

      def initialize(data)
        @data = data
        @builder_strategy = if(data.is_a?(Nokogiri::XML::Element))
          PrimitiveFromXml.new
        else
          PrimitiveFromHash.new
        end
      end

      def build_resource
        @resource = @builder_strategy.build_object @data
      end

      class PrimitiveFromHash
        def build_object(hash)
          primitive = "Shapes::Primitives::#{hash[:type]}".constantize.new hash
          primitive.ident = hash[:ident]
          primitive.description = hash[:description]
          primitive.resource_type = 'Primitive'
          primitive
        end
      end

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
end
