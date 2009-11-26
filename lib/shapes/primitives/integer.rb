module Shapes
  module Primitives
    class Integer < Shapes::Primitive

      include Shapes::Numeric

      def attributes
        { :value => @value }
      end

      protected

      def to_n(n)
        n.to_i
      end

    end
  end
end
