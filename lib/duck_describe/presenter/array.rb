module DuckDescribe
  module Presenter
    class Array < DuckDescribe::Presenter::Resource

      attr_reader :form, :struct_form

      def to_list
          content_tag :ul ,
            content_tag(:li,
              [resource.ident , link_to_edit, link_to_select_resource, link_to_delete] * ' ') << tree_to_list
      end

      def to_html(options, &block)
        'Array'
      end

    end
  end
end
