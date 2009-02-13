module Shapes
  class Constraint
    attr_reader :options

    def initialize(options = {})
      @options = options
      @constraint_serialiser = Shapes::Serialization::ConstraintSerializer::Constraint.new(self)
    end

    def name
      self.class.name.demodulize
    end

    def to_s
      @constraint_serialiser.to_s
    end
  end
end
