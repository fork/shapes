module DuckDescribe::DuckDescribeHelper

  def new_resource_link(duck)
    return if !duck || duck.new_record?
    content_tag :ul,
      content_tag(:li, link_to('New Resource', select_resource_path(duck, duck.base.path)))
  end

end
