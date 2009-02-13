module Shapes
  module Constraints
    class TypecastedArray < Shapes::Constraint

      attr_reader :types

      def initialize(options = {})
        @types =  Array(options['types'])
        super options.merge :attributes => [:types]
      end

      def update_attributes(options = {})
        @types = Array(options['types'])
      end

      def validate(resource)
        resource.children.each do |child|
          unless(@types.include?(child.serialized_classname))
            resource.errors = resource.errors.push Shapes::Error.new({:path => resource.path, :message => Shapes::TYPE_NOT_ALLOWED_WARNING.gsub(/#TYPE#/, "'#{child.serialized_classname}'")})
          end
        end
      end
    end
  end
end
