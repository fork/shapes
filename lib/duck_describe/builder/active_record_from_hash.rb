module DuckDescribe
  module Builder
    class ActiveRecordFromHash
      def build_object(hash)
        active_record = DuckDescribe::ActiveRecord.new hash
        active_record.ident = hash[:ident]
        active_record.description = hash[:description]
        active_record.record_type = hash[:type]
        active_record.record_id = hash[:record_id]
        active_record.record = active_record.active_record_class.find_by_id hash[:record_id]
        active_record
      end
    end
  end
end
