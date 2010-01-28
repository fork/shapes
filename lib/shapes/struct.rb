module Shapes
  class Struct < Shapes::Resource

    include Shapes::Container
    include Shapes::Assignment

    attr_accessor :struct, :struct_name, :record

    def self.generate_struct(name, method_array)
      const_set name, method_array.empty? ? ::Struct.new(nil) : ::Struct.new(*method_array)
    end

    def self.struct_class(struct_name, method_array)
      Shapes::Struct.const_defined?(struct_name) ?
        "Shapes::Struct::#{struct_name}".constantize :
        Shapes::Struct.generate_struct(struct_name, method_array)
    end

    def record
      @record ||= ShapeStruct.find_by_name(struct_name)
    end

    def node_attributes
      super.merge 'resource-type' => @resource_type
    end

    def read_from_node
      self.struct_name = @xml_node.name.underscore.camelize
      self.struct = build_struct(@xml_node)
      super
    end

    def update_attributes(params)
      params[:struct] and params[:struct].each do |key, value|
        children.select{ |p| p.ident == key }.first.update_attributes value
      end
      super
    end

    private

    # FIXME: add docs here (with example?)
    def build_struct(node)
      struct_values = node.xpath('struct/*[@resource-type="Primitive"]').to_a.collect{|primitive_node|
        [ primitive_node['ident'].to_sym, "Shapes::Builder::#{primitive_node['resource-type']}".
          constantize.new(primitive_node).build_resource ]
      }
      Shapes::Struct.struct_class(struct_name, struct_values.map(&:first)).new(*struct_values.map(&:last))
    end

    def xml_node_name
      struct_name.underscore.downcase.dasherize
    end

  end
end

