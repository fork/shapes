module Shapes
  module Presenter
    class ActiveRecord < Shapes::Presenter::Resource

      def form
        content_tag(:label, 'Select ActiveRecord') +
        select(:resource, :record_id, @resource.options_for_select) +
        hidden_field(:resource, :record_type)
      end

      def to_html(options, &block)
        if block_given?
          block.call(resource)
        elsif resource.record.respond_to? :to_html
          resource.record.to_html
        else
          "#{resource.record.class.name} - #{resource.path}"
        end
      end

      def class_name
        "shapesActiveRecord #{super}"
      end

    end
  end
end
