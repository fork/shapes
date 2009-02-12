module Shapes
  module Primitives
    class Boolean < Shapes::Primitive
      attr_accessor :value
      attach_shadows :assigns => :value
      def attributes
        { :value => @value }
      end
      def initialize(options = {})
        @value = value_to_boolean(options[:value])
        super
      end

      def node_attributes
        super.merge 'value' => value.to_s
      end

      def read_from_node
        @value = value_to_boolean(@xml_node[:value])
        super
      end

      def update_attributes(params)
        @value = value_to_boolean(params[:value])
        super
      end

      protected
      def value_to_boolean(value)
        if value == true || value == false
          value
        else
          %w(true t 1 on).include?(value.to_s.downcase)
        end
      end

    end
  end
end
