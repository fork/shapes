module Shapes
  module Presenter
    class Resource

      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::FormTagHelper
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::AssetTagHelper

      attr_reader :resource, :controller

      def initialize(resource, controller)
        @resource, @controller = resource, controller
      end

      def to_list
        content_tag :ul ,
          content_tag(:li,
            ["Primitive: #{resource.ident}" , link_to_edit, link_to_delete] * ' ') << tree_to_list
      end
      #link_to needs...
      def protect_against_forgery?() false end

      def tree_to_list
        resource.children.collect{|child|
          child.presenter.to_list
        }.to_s
      end

      def to_html(options, &block)
        resource.path
      end

      protected
      def link_to_delete
        link_to('Delete', controller.send(:delete_resource_path,
          :id => resource.base.shape_id, :path => resource.path),
          :method => :delete)
      end

      def link_to_edit
        link_to('Edit', controller.send(:edit_resource_path,
          :id => resource.base.shape_id, :path => resource.path))
      end

      def link_to_select_resource
        link_to('New resource', controller.send(:select_resource_path,
          :id => resource.base.shape_id, :parent_path => resource.path))
      end

    end
  end
end
