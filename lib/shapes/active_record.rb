module Shapes
  class ActiveRecord < Shapes::Resource

    include Shapes::Assignment

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

    def build_xml
      attributes = {
        :ident        => ident,
        :description  => description,
        :xml_builder => @xml_builder
      }
      record.to_shapes_xml(attributes) if record
    end

  end
end
