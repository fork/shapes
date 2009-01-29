module Shapes
  module Presenter
    module Container

      def to_list
        super { |container| content_tag(:ul, container.children_to_list, container.ul_attributes) }
      end

      protected

      def children_to_list
        resource.children.collect{|child|
            child.presenter.to_list
        }
      end

      def ul_attributes
        {:class => "shapes#{self.class.name.demodulize} shapesSortableList", :id => "#{path_to_css_selector(resource.path)}Ul", :path => resource.path}
      end

    end
  end
end
