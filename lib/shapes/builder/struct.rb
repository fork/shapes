module Shapes
  module Builder
    class Struct

      attr_reader :data
      attr_accessor :builder_strategy, :resource

      def initialize(data)
        @data = data
        @builder_strategy = if(data.is_a?(XML::Node))
          StructFromXml.new
        else
          StructFromHash.new
        end
      end

      def build_resource
        @resource = @builder_strategy.build_object @data
      end

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

      class StructFromHash
        def build_object(hash)
          struct = Shapes::Struct.new hash
          struct.ident = hash[:ident]
          struct.description = hash[:description]
          struct.struct_name = hash[:type]
          struct.resource_type = 'Struct'
          build_children(hash).each do |child|
            struct << child
          end
          struct
        end

        private

        def build_children(hash)
          shape_struct = ShapeStruct.find_by_name hash[:type]
          shape_struct.primitives.collect do |primitive|
            # hash[:struct][primitive.ident.to_sym] for empty checkboxes
            primitive_hash = hash[:struct] && hash[:struct][primitive.ident.to_sym] ? hash[:struct][primitive.ident.to_sym] : {}
            primitive.build_primitive primitive_hash
          end
        end
      end
    end
  end
end
