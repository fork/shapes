module Shapes
  module Serialization
    class ConstraintDeserializer
      # accepts a string (constraints attribute from Resource XML-node)
      # Author: hm@fork.de
      def initialize(constraints_string = '')
        @constraints_string = constraints_string.to_s
      end

      # returns an array with Constraints objects
      # Author: hm@fork.de
      def deserialize
        @constraints_string.split('|').collect { |serialized_constraint|
          Constraint.new(serialized_constraint).to_constraint
        }
      end

      # Deserializer class for serialized Constraints
      # Author: hm@fork.de
      class Constraint
        def initialize(serialized)
          @serialized = serialized
          @attribute_hash = {}
          build_attributes
        end

        def constraint_class
          "#{Shapes::Constraints}::#{@serialized.gsub(/\{{1}.*\}{1}/, '')}".constantize
        end

        def build_attributes
          @serialized.gsub(/^\w+\{{1}|\}{1}$/, '').split(';').each do | serialized_attribute |
            @attribute_hash.merge!(Shapes::Serialization::ConstraintDeserializer::Attribute.new(serialized_attribute).to_hash)
          end
         end
        
        def to_constraint
          constraint_class.new @attribute_hash
        end
      end
      
      # Deserializer class for serialized Attributes
      # Author: hm@fork.de
      class Attribute
        def initialize(serialized)
          @serialized = serialized
        end

        def to_hash
          key, value = @serialized.split(':')
          {key => deserialize_value(value)}
        end
        
        def deserialize_value(value)
          if value.match /^\[.*\]$/
            value.gsub(/^\[|\]$/, '').split(',')
          else
            value
          end
        end
      end
    end
  end
end
