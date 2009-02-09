module Shapes
  module Numeric

    attr_reader :value, :min, :max

    def initialize(options = {})
      @value = to_n(options[:value])
      @min = to_n(options[:min]) unless options[:min].blank?
      @max = to_n(options[:max]) unless options[:max].blank?
      super
    end

    def node_attributes
      {'value' => value.to_s}.merge(super)
    end

    def read_from_node
      @value = to_n(@xml_node[:value])
      @min = to_n(@xml_node[:min]) if @xml_node[:min]
      @max = to_n(@xml_node[:max]) if @xml_node[:max]
      super
    end

    def update_attributes(params)
      @value = to_n(params[:value])
      @min = params[:min].blank? ? nil : to_n(params[:min])
      @max = params[:max].blank? ? nil : to_n(params[:max])
      super
    end

    def node_attributes
      attributes = {'value' => to_n(@value)}
      attributes.merge!({'min' => @min.to_s}) if @min
      attributes.merge!({'max' => @max.to_s}) if @max
      attributes.merge(super)
    end

    protected
    def validate
      if (@max && @min) && (@max < @min)
        warning = "Max must be higher than Min."
      elsif (@max && @min) && (@max < @value || @min > @value)
        warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} between #{min} and #{max}."
      elsif (@max && @max < @value)
        warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} lower than #{max}."
      elsif (@min && @min > @value)
        warning = "#{Shapes::NUMERIC_MIN_MAX_WARNING} higher than #{min}."
      end
      warning and errors << Shapes::Error.new({:path => path, :message => warning})
      super
    end

  end
end
