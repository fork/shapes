module Shapes
  module Presenter
    class Datetime < Shapes::Presenter::Primitive

      def form
        content_tag(:label, 'Datetime') +
        select_datetime(@resource.value, :prefix => "resource[value]", :start_year => Time.new.year.to_i+10, :end_year => 1900)
      end

      def struct_form
        content_tag(:label, "Datetime (#{@resource.ident})") +
        hidden_field("resource[struct][#{@resource.ident}][ident]", @resource.ident) +
        select_datetime(@resource.value, :prefix => "resource[struct][#{@resource.ident}][value]", :start_year => Time.new.year.to_i+10, :end_year => 1900)
      end

      def to_html(options, &block)
        block_given? ? block.call(resource) : resource.value.to_s
      end
    end
  end
end
