module Shapes
  module Constraints
    class NumericRange < Shapes::Constraint

      attr_reader :min, :max

      def initialize(options = {})
        @min, @max = options['min'].to_f, options['max'].to_f
        super options.merge(:attributes => [:min, :max])
      end

      def update_attributes(options = {})
        @min, @max = options['min'].to_f, options['max'].to_f
      end

      def validate(resource)
        if (@max && @min) && (@max < @min)
          warning = "Max must be higher than Min."
        elsif (@max && @min) && (@max < resource.value || @min > resource.value)
          warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} between #{min} and #{max}."
        elsif (@max && @max < resource.value)
          warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} lower than #{max}."
        elsif (@min && @min > resource.value)
          warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} higher than #{min}."
        end
        warning and resource.errors = (resource.errors << Shapes::Error.new({:path => resource.path, :message => warning}))
      end
    end
  end
end
