module Shapes
  module Presenter
    class Struct < Shapes::Presenter::Resource

      def to_list
          content_tag :ul ,
            content_tag(:li,
              ["Struct: #{resource.ident}" , link_to_edit, link_to_delete] * ' ')
      end

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

    end
  end
end
