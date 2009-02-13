module Shapes::ShapesHelper

  def shape_form(shape, type, &block)
    path, method = (type == :edit) ?
      [shape_path(shape), :put] :
      [shapes_path, :post]
    form_for :shape, shape,
          :url => path,
          :html => {:method => method},
          &block
  end

end
