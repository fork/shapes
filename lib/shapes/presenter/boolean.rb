module Shapes
  module Presenter
    class Boolean < Shapes::Presenter::Primitive

      def form
        content_tag(:label, 'Value') +
        check_box(:resource, :value)
      end

      def struct_form
        content_tag(:label, "Value (#{@resource.ident})") +
        hidden_field("resource[struct][#{@resource.ident}][ident]", @resource.ident) +
        check_box_tag("resource[struct][#{@resource.ident}][value]", '1', @resource.value)
      end

      def to_html(options, &block)
       resource.value.to_s
      end

    end
  end
end
