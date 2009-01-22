module DuckDescribe  
  class ActiveRecord < DuckDescribe::Resource

    attr_accessor :record_id, :record_type, :record

    def active_record_class
      record_type.constantize
    end

    def record
      @record ||= active_record_class.find_by_id record_id
    end

    def options_for_select
      active_record_class.find_in_scope.collect{ |active_record|
        [active_record.name_for_select, active_record.id.to_s]
      }
    end

    def read_from_node
      @record_id = @xml_node['record-id']
      @record_type = @xml_node.name.underscore.camelize
      super
    end

    def update_attributes(params)
      @record_type = params[:record_type]
      @record_id = params[:record_id]
      super
    end

    def to_xml
      new_resource and assign_appearance
      record and record.to_duck_xml({:ident => ident, 
        :description => description, :builder => xml_builder})
    end

    def assign_appearance
      duck = Duck.find_by_id base.duck_id
      appearance = record.duck_appearances.
        build(:duck => duck, :path => path)
      appearance.save
    end

  end
end
