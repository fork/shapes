module Shapes

  module Container

    # accepts a xml node, builds a resource based on this node and adds this object to childrens
    # Author: hm@fork.de
    def build_child_from_xml(node)
      child = "Shapes::Builder::#{node['resource-type'].camelize}".
        constantize.new(node).build_resource
      self << child
      child.from_xml
      child
    end

    # accepts a resource and defines its relationship to self
    # Author: hm@fork.de
    def <<(child)
      child.parent = self
      children << child
    end

    # accepts an array of numbers used to rearrange the child elements
    # Author: hm@fork.de
    def sort_children(id_array)
      @children = id_array.collect {|id| children[id.to_i]}
    end

    # FIXME: refactor Magic Number
    def from_xml
      @xml_node.find('*[@resource-type="Struct"]|*[@resource-type="Primitive"]|*[@resource-type="ActiveRecord"]').collect{|child_node|
        build_child_from_xml child_node
      }
    end

    # destroys self and calls destroy on each child
    # Author: hm@fork.de
    def destroy
      children.each { |child| child.destroy }
      super
    end

    # passes the xml_builder to each child and generates the xml of them
    # Author: hm@fork.de
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
