module DuckDescribe  
  module Primitives
    class Float < DuckDescribe::Primitive
      attr_accessor :value
      def initialize(options = {})
        @value = (options[:value] || 0).to_f
        super
      end

      def node_attributes
        {'value' => value.to_s}.merge(super)
      end      

      def read_from_node
        @value = @xml_node['value'].to_f
        super
      end

      def update_attributes(params)
        @value = params[:value].to_f
        super
      end
    end
  end
end
