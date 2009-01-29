module Shapes
  module Presenter
    class Struct < Shapes::Presenter::Resource

      def form
        @resource.children.collect {|primitive|
          primitive.presenter.struct_form
        }
      end

      def to_html(options, &block)
        @resource.struct.collect {|primitive|
          primitive.presenter.to_html {}
        }
      end

      def class_name
        "shapesStruct #{super}"
      end

    end
  end
end
