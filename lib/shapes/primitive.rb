module Shapes
  class Primitive < Shapes::Resource

    @primitives = Set.new
    def self.primitives
      @primitives
    end

    def node_attributes
      super.merge 'resource-type' => @resource_type
    end

    def self.inherited(descendant)
      @primitives << descendant
    end

    #def partial_path
    #  "#{super}/#{self.class.name.demodulize.underscore}"
    #end

  end
end
