module Shapes

  module Container

    def build_child_from_xml(node)
      child = "Shapes::Builder::#{node['resource-type'].camelize}".
        constantize.new(node).build_resource
      self << child
      child.from_xml
      child
    end

    def <<(child)
      child.parent = self
      children << child
    end

    # FIXME: refactor Magic Number
    def from_xml
      @xml_node.find('*[@resource-type="Struct"]|*[@resource-type="Primitive"]|*[@resource-type="ActiveRecord"]').collect{|child_node|
        build_child_from_xml child_node
      }
    end

    def destroy
      children.each { |child| child.destroy }
      super
    end

    def add_node_content
      children.collect{|child|
        child.xml_builder = xml_builder
        child.to_xml
      }
      super
    end

    def errors
      (super | children.map(&:errors)).flatten
    end

    def validate
      children.map(&:validate)
      super
    end

  end
end
