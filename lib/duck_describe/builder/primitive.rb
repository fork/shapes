module DuckDescribe
  module Builder
    class Primitive

      attr_reader :data
      attr_accessor :builder_strategy, :resource

      def initialize(data)
        @data = data
        @builder_strategy = if(data.is_a?(XML::Node))
          DuckDescribe::Builder::PrimitiveFromXml.new
        else
          DuckDescribe::Builder::PrimitiveFromHash.new
        end
      end

      def build_resource
        @resource = @builder_strategy.build_object @data
      end
    end
  end
end