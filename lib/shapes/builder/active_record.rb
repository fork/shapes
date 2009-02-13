module Shapes
  module Builder
    class ActiveRecord

      attr_reader :data
      attr_accessor :builder_strategy, :resource

      def initialize(data)
        @data = data
        @builder_strategy = if(data.is_a?(XML::Node))
          ActiveRecordFromXml.new
        else
          ActiveRecordFromHash.new
        end
      end

      def build_resource
        @resource = @builder_strategy.build_object @data
      end

      class ActiveRecordFromHash
        def build_object(hash)
          active_record = Shapes::ActiveRecord.new hash
          active_record.ident = hash[:ident]
          active_record.description = hash[:description]
          active_record.record_type = hash[:type]
          active_record.record_id = hash[:record_id]
          active_record.record = active_record.active_record_class.find_by_id hash[:record_id]
          active_record.resource_type = 'ActiveRecord'
          active_record
        end
      end

      class ActiveRecordFromXml
        def build_object(node)
          active_record = Shapes::ActiveRecord.new hash
          active_record.xml_node = node
          active_record.read_from_node
          active_record
        end
      end
    end
  end
end
