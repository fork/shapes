module Shapes
  module Primitives
    class Datetime < Shapes::Primitive

      attr_accessor :value
      alias_method :value, :preview

      def attributes
        { 
          :value => @value,
          :ident => :ident
        }
      end

      def initialize(options = {})
        @value = if options['value']
          params_to_datetime options['value']
        else
          today
        end
        super
      end

      def node_attributes
        super.merge 'value' => value.to_s
      end

      def read_from_node
        @value = @xml_node['value'].blank? ? today : DateTime.parse(@xml_node['value'])
        super
      end

      def update_attributes(params)
        @value = params_to_datetime params['value']
        super
      end

      def preview
        I18n.l @value
      end

      protected

      def today
        DateTime.ordinal Time.new.year
      end

      def params_to_datetime(params)
        params = params.inject({}) { |m, p| m.merge p.first => p.last.to_i }
        values = params.values_at 'year', 'month', 'day', 'hour', 'minute'
        DateTime.civil *values
      end
    end
  end
end
