module DuckDescribe
  module Builder
    class PrimitiveFromHash
      def build_object(hash)
        primitive = "DuckDescribe::Primitives::#{hash[:type]}".constantize.new hash
        primitive.ident = hash[:ident]
        primitive.description = hash[:description]
        primitive
      end
    end
  end
end
