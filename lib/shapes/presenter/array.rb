module Shapes
  module Presenter
    class Array < Shapes::Presenter::Primitive

      include Shapes::Presenter::Container

      attr_reader :form, :struct_form

      def to_html(options, &block)
        'Array'
      end

      protected

      def link_to_select_resource
        link_to('New resource', controller.send(:select_resource_path,
          :id => resource.base.shape_id, :parent_path => resource.path))
      end

    end
  end
end
