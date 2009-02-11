module Shapes
  module Presenter
    class Numeric < Shapes::Presenter::Primitive

      def form
        content_tag(:label, 'Value') +
        text_field(:resource, :value) +
        content_tag(:label, 'Min') +
        text_field(:resource, :min) +
        content_tag(:label, 'Max') +
        text_field(:resource, :max)
      end

      def struct_form
        content_tag(:label, "Value (#{@resource.ident})") +
        hidden_field("resource[struct][#{@resource.ident}][ident]", @resource.ident) +
        text_field_tag("resource[struct][#{@resource.ident}][value]", @resource.value) +
        content_tag(:label, "Min") +
        text_field_tag("resource[struct][#{@resource.ident}][min]", @resource.min) +
        content_tag(:label, "Max") +
        text_field_tag("resource[struct][#{@resource.ident}][max]", @resource.max)
      end

      def to_html(options, &block)
       resource.value.to_s
      end

    end
  end
end
