module Shapes
  class Primitive < Shapes::Resource

    @primitives = Set.new
    def self.primitives
      @primitives
    end

    def node_attributes
      super.merge 'resource-type' => 'Primitive'
    end

    def self.inherited(descendant)
      @primitives << descendant
    end

  end
end
