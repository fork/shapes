module Shapes
  module Primitives
    class Array < Shapes::Primitive
      include Shapes::Container

      def initialize(options = {})
        @applicable_constraints = [Shapes::Constraints::TypecastedArray]
        super
      end

     end
  end
end
