module DuckDescribe::DuckDescribeHelper

  def new_resource_link(duck)
    return if !duck || duck.new_record?
    content_tag(:li, link_to('Add Resource', select_resource_path(duck, duck.base.path)))
  end

  def new_primitive_link(duck_struct)
    return if !duck_struct || duck_struct.new_record?
    content_tag(:li, link_to('Add Primitive', new_duck_struct_duck_struct_primitive_path(duck_struct)))
  end

  def navigation
    render :partial => '/duck_describe/navigation.html.erb'
  end

end
