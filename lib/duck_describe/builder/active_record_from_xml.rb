module DuckDescribe
  module Builder    
    class ActiveRecordFromXml
      def build_object(node)
        active_record = DuckDescribe::ActiveRecord.new hash
        active_record.xml_node = node
        active_record.read_from_node
        active_record
      end
    end
  end
end
