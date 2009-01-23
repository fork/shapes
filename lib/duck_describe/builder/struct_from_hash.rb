module DuckDescribe
  module Builder
    class StructFromHash

      def build_object(hash)
        struct = DuckDescribe::Struct.new hash
        struct.ident = hash[:ident]
        struct.description = hash[:description]
        struct.struct_name = hash[:type]
        build_children(hash).each do |child|
          struct << child
        end
        struct
      end

      private

      def build_children(hash)
        duck_struct = DuckStruct.find_by_name hash[:type]
        duck_struct.primitives.collect do |primitive|
          # hash[:struct][primitive.ident.to_sym] for empty checkboxes
          primitive_hash = hash[:struct] && hash[:struct][primitive.ident.to_sym] ? hash[:struct][primitive.ident.to_sym] : {}
          primitive.build_primitive primitive_hash
        end
      end

    end
  end
end
