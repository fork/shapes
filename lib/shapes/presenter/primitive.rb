module Shapes
  module Presenter
    class Primitive < Shapes::Presenter::Resource

      def class_name
        "shapesPrimitive shapes#{self.class.name.demodulize} #{super}"
      end

    end
  end
end
