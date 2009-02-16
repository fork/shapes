module Shapes
  module Primitives
    class Array < Shapes::Primitive
      include Shapes::Container
      attach_shadows
      def attributes
        {}
      end
      def initialize(options = {})
        @applicable_constraints = [Shapes::Constraints::TypecastedArray]
        super
      end
    end
  end
end
