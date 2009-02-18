module Shapes
  module Presenter
    class Base < Shapes::Presenter::Resource
      include Shapes::Presenter::Container

      def to_list
        content_tag(:ul, children_to_list, ul_attributes)
      end

      protected

      def ul_attributes
        super.merge 'shapeId' => resource.base.shape_id
      end
    end
  end
end
