module DuckDescribe
  module Presenter
    class File < DuckDescribe::Presenter::Resource

      def form
        content_tag(:label, 'File') +
        file_field(:resource, :value) +
        check_box_tag('resource[remove_file]')
      end

      def struct_form
        content_tag(:label, "File (#{@resource.ident})") +
        hidden_field("resource[struct][#{@resource.ident}][ident]", @resource.ident) +
        file_field_tag("resource[struct][#{@resource.ident}][value]") +
        check_box_tag("resource[struct][#{@resource.ident}][remove_file]")
      end

      def to_html(options, &block)
        return block.call(resource) if block_given?
        resource.content_type.match(/^image\//) ? image_tag(resource.relative_path) : resource.relative_path
      end

    end
  end
end
