module DuckDescribe
  module Presenter
    class String < DuckDescribe::Presenter::Resource

      def form
        content_tag(:label, 'Text') +
        text_area(:resource, :value)
      end

      def struct_form
        content_tag(:label, "Text (#{@resource.ident})") +
        hidden_field("resource[struct][#{@resource.ident}][ident]", @resource.ident) +
        text_area_tag("resource[struct][#{@resource.ident}][value]", @resource.value)
      end

      def to_html(options, &block)
       resource.value
      end

    end
  end
end
