module DuckDescribe  
  class Struct < DuckDescribe::Resource

    include DuckDescribe::Container

    attr_accessor :struct, :struct_name

    def self.generate_struct(name, method_array)      
      const_set name, method_array.empty? ? ::Struct.new(nil) : ::Struct.new(*method_array)
    end

    def self.struct_class(struct_name, method_array)
      DuckDescribe::Struct.const_defined?(struct_name.camelize) ?
        "DuckDescribe::Struct::#{struct_name.camelize}".constantize :
        DuckDescribe::Struct.generate_struct(struct_name.camelize, method_array)
    end
    
    def struct
     # @struct ||= 
    end

    def node_attributes
      {'resource-type' => 'Struct'}.merge super
    end

    def read_from_node
      self.struct_name = @xml_node.name.underscore.classify
      self.struct = build_struct(@xml_node)
      super
    end
  
    def update_attributes(params)
      params[:struct] and params[:struct].each do |key, value|
        children.select{|p| p.ident == key}.first.update_attributes value
      end
      super
    end

    def destroy
      children.each do |primitive|
        primitive.destroy
      end
      super
    end

    def install_presenter(controller)
      children.each do |primitive|
        primitive.install_presenter controller
      end
      super
    end

    private

    def build_struct(node)
      struct_values = node.find('struct/*[@resource-type="Primitive"]').to_a.collect{|primitive_node|
        [ primitive_node['ident'].to_sym, "DuckDescribe::Builder::#{primitive_node['resource-type']}".
          constantize.new(primitive_node).build_resource ]
      }
      DuckDescribe::Struct.struct_class(struct_name, struct_values.map(&:first)).new(*struct_values.map(&:last))
    end

    def xml_node_name
      struct_name.underscore.downcase.dasherize
    end

  end
end

