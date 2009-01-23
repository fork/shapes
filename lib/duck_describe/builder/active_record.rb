module DuckDescribe
  module Builder
    class ActiveRecord

      attr_reader :data
      attr_accessor :builder_strategy, :resource

      def initialize(data)
        @data = data
        @builder_strategy = if(data.is_a?(XML::Node))
          DuckDescribe::Builder::ActiveRecordFromXml.new
        else
          DuckDescribe::Builder::ActiveRecordFromHash.new
        end
      end

      def build_resource
        @resource = @builder_strategy.build_object @data
      end
    end
  end
end