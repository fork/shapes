module Shapes
  module Primitives
    class Integer < Shapes::Primitive
      include Shapes::Numeric

      protected
      def to_n(n)
        n.to_i
      end
    end
  end
end
