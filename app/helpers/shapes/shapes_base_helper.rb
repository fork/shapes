module Shapes::ShapesBaseHelper

  include Shapes::CommonHelper

  def shape_form(shape, type, &block)
    path, method = (type == :edit) ?
      [shape_path(shape), :put] :
      [shapes_path, :post]
    form_for :shape, shape,
          :url => path,
          :html => {:method => method},
          &block
  end

  def new_resource_link(shape)
    return if !shape || shape.new_record?
    content_tag(:li, link_to('Add resource', select_resource_path(shape, shape.base.path)))
  end

  def new_shape_shape_struct_link(shape)
    return if !shape || shape.new_record?
    content_tag(:li, link_to('Add local struct', new_shape_shape_struct_path(shape)))
  end

  def new_primitive_link(shape_struct)
    return if !shape_struct || shape_struct.new_record?
    content_tag(:li, link_to('Add primitive', new_shape_struct_shape_struct_primitive_path(shape_struct)))
  end

  def navigation
    render :partial => 'shapes/navigation.html.erb'
  end

end
