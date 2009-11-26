module Shapes
  class ActiveRecord < Shapes::Resource

    attr_accessor :record_id, :record_type, :record

    # Returns class name of record
    # Author: hm@fork.de
    def active_record_class
      record_type.constantize
    end

    # Returns record for record_id in scope.
    #
    # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
    def record
      @record ||= active_record_class.shape_scope(base).find_by_id record_id
    end

    # Returns nested array of scoped records to use with options_for_select.
    #
    # Author: Florian Aßmann (flazy@fork.de) [2009-02-05]
    def options_for_select
      active_record_class.shape_scope(base).
      map { |active_record| [ active_record.shape_name, active_record.id ] }
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

    def build_xml
      assign_record if new_resource?

      attributes = {
        :ident        => ident,
        :description  => description,
        :xml_builder => @xml_builder
      }
      record.to_shapes_xml(attributes) if record
    end

    # assigns record to Shape
    # Author: hm@fork.de
    def assign_record
      assignment = record.shape_assignments.
        build(:shape => base.shape, :path => path)
      assignment.save
    end

    # destroys assignments
    # Author: hm@fork.de
    def free_record
      assignment = record.shape_assignments.
        find(:first, :conditions => {:shape_id => base.shape.id, :path => path})
      assignment and assignment.destroy
    end

  end
end
