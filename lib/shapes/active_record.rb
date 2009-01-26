module Shapes
  class ActiveRecord < Shapes::Resource

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
      free_record
      super
    end

    def to_xml
      assign_record if new_resource?

      attributes = {
        :ident        => ident,
        :description  => description,
        :builder      => xml_builder
      }
      record.to_shape_xml attributes if record
    end

    def assign_record
      assignment = record.shape_assignments.
        build(:shape => base.shape, :path => path)
      assignment.save
    end

    def free_record
      assignment = record.shape_assignments.
        find(:first, :conditions => {:shape_id => base.shape.id, :path => path})
      assignment and assignment.destroy
    end

  end
end
