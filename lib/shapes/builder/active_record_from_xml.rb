module Shapes
  module Builder
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
