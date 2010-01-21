module Shapes
  acts_as_shape 'ShapeStruct',
    :include      => :shape_struct_primitives,
    :select_name  => proc { "#{ name } - #{ id }" }#,
    :scope        => proc { |shape|
      Hash[ :conditions => { :scope_attribute => shape.scope_attribute } ]
    }
end
