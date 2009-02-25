module Shapes
  module Constraints
    attr_accessor :constraints

    def initialize(*args)
      @constraints = []
    end

    def applicable_constraints
      @applicable_constraints || []
    end

    # builds an array of option tags with all possible constraints that are not imposed to the resource
    # Author: hm@fork.de
    def select_constraint_type
      left_constraints.collect do |constraint|
        [constraint.name.demodulize, constraint.name] unless(constraints.include?(constraint.name.demodulize.underscore))
      end
    end

    def delete_constraint_by_name(constraint_name)
      @constraints.delete_if {|c| c.name == constraint_name}
    end

    def find_constraint_by_type(constraint_name)
      @constraints.collect{|c| c if c.name == constraint_name}.first
    end

    def left_constraints
      constraint_classes = @constraints.collect{ |c| c.class }
      applicable_constraints.collect { |c|
        c unless constraint_classes.include?(c)
      }.compact
    end

    def read_from_node
      @constraints  = Shapes::Serialization::ConstraintDeserializer.new(@xml_node['constraints']).deserialize
    end

    def node_attributes
      @constraints.empty? ? {} : {'constraints' => Shapes::Serialization::ConstraintSerializer.new(@constraints).serialize}
    end

    def serialized_classname
      "#{resource_type}-#{self.class.name.demodulize}"
    end

    protected

    def validate
      @constraints.collect { |c| c.validate(self) }
    end
  end
end
