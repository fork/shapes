module DuckDescribe
  module Presenter
    class Struct < DuckDescribe::Presenter::Resource

      def to_list
          content_tag :ul ,
            content_tag(:li,
              [resource.ident , link_to_edit, link_to_select_resource, link_to_delete] * ' ') << tree_to_list
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
