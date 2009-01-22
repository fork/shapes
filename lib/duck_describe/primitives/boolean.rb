module DuckDescribe  
  module Primitives
    class Boolean < DuckDescribe::Primitive
      attr_accessor :value
      def initialize(options = {})
        @value = value_to_boolean(options[:value])
        super
      end

      def node_attributes
        {'value' => value.to_s}.merge(super)
      end

      def value_to_boolean(value)
        if value == true || value == false
          value
        else
          %w(true t 1 on).include?(value.to_s.downcase)
        end
      end      
 
      def read_from_node
        @value = value_to_boolean(@xml_node[:value])
        super
      end

      def update_attributes(params)
        @value = value_to_boolean(params[:value])
        super
      end
    end
  end
end
