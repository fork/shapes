module Shapes
  module Serialization
    class ConstraintSerializer
      # accepts an Array of Shapes::Constraints::Constraint
      # Author: hm@fork.de
      def initialize(constraints)
        @constraints = constraints
      end

      # returns serialized constraints
      # Author: hm@fork.de
      def serialize
        @constraints.collect { |deserialized_constraint|
          deserialized_constraint.to_s
        } * "|"
      end

      # Serializer class for deserialized constraints
      # Author: hm@fork.de
      class Constraint
        def initialize(constraint)
          @constraint = constraint
        end

        def serializable_attributes
          Array(@constraint.options[:attributes]).collect { |a| a.to_s }
        end

        def attributes
          serializable_attributes.collect{|attribute|
            Shapes::Serialization::ConstraintSerializer::Attribute.new attribute, @constraint
          }
        end

        def to_s
          "#{@constraint.name}{#{attributes.collect{|attribute| attribute.to_s} * ';'}}"
        end
      end

      # Serializer class for attributes of Constraint objects
      # Author: hm@fork.de
      class Attribute
        def initialize(name, constraint)
          @name, @constraint = name, constraint
          @value = @constraint.send(name)
        end

        def to_s
          "#{@name}:#{serialized_value}"
        end

        def serialized_value
          if @value.is_a?(Array)
            "[#{@value * ','}]"
          else
            @value
          end
        end
      end
    end
  end
end
