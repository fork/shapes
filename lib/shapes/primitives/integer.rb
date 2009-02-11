module Shapes
  module Primitives
    class Integer < Shapes::Primitive
      attach_shadows :assigns => :attributes
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
