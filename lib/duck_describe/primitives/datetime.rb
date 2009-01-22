module DuckDescribe  
  module Primitives
    class Datetime < DuckDescribe::Primitive
      attr_accessor :value
      def initialize(options = {})
        @value = if options['value']
          params_to_datetime options['value']
        else
          DateTime.ordinal Time.new.year
        end
        super
      end

      def node_attributes
        {'value' => value.to_s}.merge(super)
      end

      def read_from_node
        @value = DateTime.parse @xml_node['value']
        super
      end

      def update_attributes(params)
        @value = params_to_datetime params['value']
        super
      end
      
      def params_to_datetime(params)
        DateTime.civil(params['year'].to_i, params['month'].to_i, params['day'].to_i, params['hour'].to_i, params['minute'].to_i)
      end
    end
  end
end
