module Shapes
  module Builder
    class PrimitiveFromHash
      def build_object(hash)
        primitive = "Shapes::Primitives::#{hash[:type]}".constantize.new hash
        primitive.ident = hash[:ident]
        primitive.description = hash[:description]
        primitive
      end
    end
  end
end
