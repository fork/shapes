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

      attr_reader :resource, :controller, :link_to_select_resource

      def initialize(resource, controller)
        @resource, @controller = resource, controller
      end

      def to_list
        container_ul = yield(self) if block_given?
        content_tag(:li,
          ["#{self.class.name.demodulize}: #{resource.ident}", link_to_show_constraints, link_to_edit, link_to_select_resource, link_to_delete] * ' ' + container_ul.to_s , li_attributes)
      end

      #link_to needs...
      def protect_against_forgery?() false end

      def to_html(options, &block)
        resource.path
      end

      protected

      def path_to_css_selector(path)
        #need underscores in selector to ensure uniqueness of css id
        path.split(/#/).delete_if { |x| x.blank? }.collect {|x| x.camelize(:lower) } * '_'
      end

      def li_attributes
        {:class => class_name, :id => "#{path_to_css_selector(resource.path)}Li", :path => resource.path}
      end

      def link_to_delete
        link_to('Delete', controller.send(:delete_resource_path,
          :id => resource.base.shape_id, :path => resource.path),
          :method => :delete)
      end

      def link_to_show_constraints
        return if resource.applicable_constraints.empty?
        link_to('Show constraints', controller.send(:show_constraints_path,
          :id => resource.base.shape_id, :path => resource.path))
      end

      def link_to_edit
        link_to('Edit', controller.send(:edit_resource_path,
          :id => resource.base.shape_id, :path => resource.path))
      end

      def class_name; "shapesResource"; end

    end
  end
end
