module Shapes
  # example configuration
  #
  def self.config
    {
  #    'ShapeStruct' => {
  #        :include => :shape_struct_primitives,
  #        :scope => {},
  #        :select_name => proc { |p| "#{p.name} - #{p.id}"}
  #    }
    }
  end
  # Idea:
  # acts_as_shape 'ShapeStruct',
  #   :include => :shape_struct_primitives,
  #   :scope => {},
  #   :select_name => proc { |p| "#{p.name} - #{p.id}"}

end

