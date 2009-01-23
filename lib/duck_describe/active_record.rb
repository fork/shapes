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
      @record_id    = @xml_node['record-id']
      @record_type  = @xml_node.name.underscore.camelize
      super
    end

    def update_attributes(params)
      @record_type = params[:record_type]
      @record_id = params[:record_id]
      super
    end

    def destroy
      unassign_appearance
      super
    end

    def to_xml
      assign_appearance if new_resource?

      attributes = {
        :ident        => ident,
        :description  => description,
        :builder      => xml_builder
      }
      record.to_duck_xml attributes if record
    end

    def assign_appearance
      appearance = record.duck_appearances.
        build(:duck => base.duck, :path => path)
      appearance.save
    end

    def unassign_appearance
      appearance = record.duck_appearances.
        find(:first, :conditions => {:duck_id => base.duck.id, :path => path})
      appearance and appearance.destroy
    end

  end
end
