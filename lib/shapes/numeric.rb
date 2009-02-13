module Shapes
  module Numeric

    attr_reader :value

    def initialize(options = {})
      @applicable_constraints = [Shapes::Constraints::NumericRange]
      @value = to_n(options[:value])
      super
    end

    def node_attributes
      super.merge 'value' => value.to_s
    end

    def read_from_node
      @value = to_n @xml_node[:value]
      super
    end

    def update_attributes(params)
      @value = to_n params[:value]
      super
    end

    def node_attributes
      super.merge 'value' => to_n(@value)
    end

  end
end
