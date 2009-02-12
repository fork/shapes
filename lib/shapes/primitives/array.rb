module Shapes
  module Primitives
    class Array < Shapes::Primitive
      include Shapes::Container
      attach_shadows
      def attributes
        {}
      end
    end
  end
end
