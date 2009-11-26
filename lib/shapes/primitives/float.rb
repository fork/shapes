module Shapes
  module Primitives
    class Float < Shapes::Primitive

      include Shapes::Numeric

      def attributes
        { :value => @value }
      end

      protected

      def to_n(n)
        n.to_f
      end

    end
  end
end
