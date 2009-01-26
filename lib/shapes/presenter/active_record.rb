module Shapes
  module Presenter
    class ActiveRecord < Shapes::Presenter::Resource

      def to_list
          content_tag :ul ,
            content_tag(:li,
              ["ActiveRecord: #{resource.ident}" , link_to_edit, link_to_delete] * ' ') << tree_to_list
      end

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

    end
  end
end
