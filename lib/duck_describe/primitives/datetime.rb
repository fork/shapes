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
        super.merge 'value' => value.to_s
      end

      def read_from_node
        @value = DateTime.parse @xml_node['value']
        super
      end

      def update_attributes(params)
        @value = params_to_datetime params['value']
        super
      end

      protected
      def params_to_datetime(params)
        params = params.inject({}) { |m, p| m.merge p.first => p.last.to_i }
        values = params.values_at 'year', 'month', 'day', 'hour', 'minute'
        DateTime.civil *values
      end
    end
  end
end
