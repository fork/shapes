module Shapes
  module Primitives
    class Float < Shapes::Primitive
      include Shapes::Numeric
      protected
      def to_n(n)
        n.to_f
      end
    end
  end
end
