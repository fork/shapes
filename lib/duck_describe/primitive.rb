module DuckDescribe  
  class Primitive < DuckDescribe::Resource
    
    @primitives = []
    class << self
      attr_reader :primitives
    end

    def node_attributes
      {'resource-type' => 'Primitive'}.merge(super)
    end
    
    def self.inherited(descendant)
      (@primitives << descendant).uniq!
    end

  end
end

# load primitives
Dir[File.join(File.dirname(__FILE__), 'primitives', '*.rb')].each { |primitive| require primitive}
