module Shapes
   #acts_as_shape 'ShapeStruct',
   #  :include      => :shape_struct_primitives,
   #  :select_name  => proc { |r| "#{ r.name } - #{ r.id }"},
   #  :scope        => proc { |shape| { :conditions => { :language_id => shape.language_id } } }
end
