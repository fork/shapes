module Shapes::StructPrimitivesHelper

  include Shapes::CommonHelper

  def shape_struct_primitive_form(shape_struct_primitive, type, &block)
    path, method = (type == :edit) ?
      [shape_struct_shape_struct_primitive_path(shape_struct_primitive.shape_struct, shape_struct_primitive), :put] :
      [shape_struct_shape_struct_primitives_path(shape_struct_primitive.shape_struct.id), :post]
    form_for :shape_struct_primitive, shape_struct_primitive,
          :url => path,
          :html => {:method => method},
          &block
  end

end
