module Shapes::StructsHelper

  include Shapes::CommonHelper

  def shape_struct_form(shape_struct, type, &block)
    if @shape
      path, method = (type == :edit) ?
        [shape_shape_struct_path(:shape => @shape, :shape_struct => shape_struct), :put] :
        [shape_shape_struct_index_path(@shape), :post]
    else
      path, method = (type == :edit) ?
        [shape_struct_path(shape_struct), :put] :
        [shape_structs_path, :post]
    end
    form_for :shape_struct, shape_struct,
          :url => path,
          :html => {:method => method},
          &block
  end

end
