module Shapes::CommonHelper

  def path_to_css_selector(path)
    #need underscores in selector to ensure uniqueness of css id
    path.split(/#/).delete_if { |x| x.blank? }.collect {|x| x.camelize(:lower) } * '_'
  end

  def shapes_navigation_item(name, url, new_title, new_url, active)
    span = content_tag :span, name
    ahref = link_to span << shapes_navigation_item_plus(new_url, new_title).to_s, url
    content_tag :li, ahref, (active ? { :class =>  'active' } : {})
  end
  def shapes_navigation_item_plus(url, title)
    icon = image_tag '/shapes/images/icons/plus.png'
    span = content_tag :span, content_tag(:span, icon)
    link_to span, url, { :class => 'plus', :title => title }
  end
  def structs_active?
    request.env['REQUEST_PATH'].match(/structs/)
  end

  def link_to_handle(resource)
    return '' if @noscript
    return dummy_icon if resource.struct_resource?
    link_to '', '#', 
      { :class => 'icon handle', 
        :onclick => 'Shapes.closeAllPropertyChangers()', 
        :title => 'Sort resources' }
  end

  def link_to_edit_resource(resource)
    return dummy_icon if resource.struct_resource?
    path = edit_resource_path(:id => resource.base.shape_id, :path => resource.path)
    link_to '', path, 
      { :onclick => "Shapes.openPropertyChanger(Shapes.parentLiFor(this)); Shapes.renderUrlInElement(Shapes.parentLiFor(this), '#{ path }'); return false;", 
        :class => 'icon edit', 
        :title => 'Edit resource' }
  end

  def link_to_delete_resource(resource)
    return dummy_icon if resource.struct_resource?
    link_to '', 
      delete_resource_path(:id => resource.base.shape_id, :path => resource.path), 
      { :onclick => "Shapes.openPropertyChanger(Shapes.parentLiFor(this)); Shapes.renderUrlInElement(Shapes.parentLiFor(this), '#{ resource_delete_confirmation_path resource.base.shape_id, resource.path }'); return false;", 
        :class => 'icon delete', 
        :title => 'Delete resource' }
  end

  def link_to_new_resource(resource)
    return dummy_icon unless resource.name == 'Array'
    path = select_resource_path :id => resource.base.shape_id, :parent_path => resource.path
    link_to '', path, 
      { :onclick => "Shapes.openPropertyChanger(Shapes.parentLiFor(this)); Shapes.renderUrlInElement(Shapes.parentLiFor(this), '#{ path }'); return false;", 
        :class => 'icon add', 
        :title => 'Add resource' }
  end

  def link_to_new_resource_for_base(base_resource)
    path = select_resource_path :id => base_resource.shape_id, :parent_path => base_resource.path
    link_to 'Add resource', path, 
      { :onclick => "Shapes.openFormForBaseElement('#{ path }'); return false;", 
        :title => 'Add resource' }
  end

  def link_to_fold_resource(resource)
    return '' if @noscript || resource.children.blank?
    ul_id = "#{path_to_css_selector(resource.path)}Ul"
    toggle_js = "Shapes.toggleArrayContent('#{ ul_id }', '#{ resource.path }');"
    link = link_to('', '#', { :onclick => "#{ toggle_js } return false;", 
        :class => 'icon foldIcon', :title => 'Fold/Unfold resource' })
    link + javascript_tag("$('#{ ul_id }').up('li').down('span.liContent').observe('dblclick', function(event){#{ toggle_js }});")
  end

  def link_to_show_constraints(resource)
    return dummy_icon if resource.applicable_constraints.empty? or resource.struct_resource?
    show_contraints_url = show_constraints_path(:id => resource.base.shape_id, :path => resource.path)
    link_to '', show_contraints_url, 
      { :onclick => "Shapes.openPropertyChanger(Shapes.parentLiFor(this)); Shapes.renderUrlInElement(Shapes.parentLiFor(this), '#{show_contraints_url}'); return false;", 
        :class => 'icon constraints', 
        :title => 'Show constraints' }
  end

  def icon_to_cancel_form
    link_to '', '#', 
      { :onclick => "Shapes.renderResource(Shapes.parentLiFor(this)); return false;", 
        :title => 'Cancel', 
        :class => 'icon cancel' }
  end

  def link_to_cancel_form
    link_to '', '#', 
      { :onclick => "Shapes.renderResource(Shapes.parentLiFor(this)); return false;", 
        :title => 'Cancel', 
        :class => 'cancelForm' }
  end

  def dummy_icon
    content_tag :span, '', { :class => 'icon' }
  end

  def show_resource_name(name)
    content_tag :span, name,
      { :class => "text resourceName #{ name}" }
  end

  def show_resource_ident(ident)
    content_tag :span, ident,
      { :class => "text resourceIdent" }
  end

  # decrease depth because base is not in list
  def resource_indentation(depth)
    indent_str = ''
    (depth - 2).times do | i |
      indent_str << content_tag(:span, '',
        { :class => 'indent' })
    end
    if depth > 1
      indent_str << content_tag(:span, image_tag('/shapes/images/list/tab.png'),
        { :class => 'indent' })
    end
    indent_str
  end

  # decrease depth by one because base is not in list
  def resource_form_indentation(depth)
    (depth - 1) * 40
  end

  def resource_li(resource, counter)
    css_classes = "dottedLiLine shapesResource sortable #{ resource.class.name.demodulize.camelize(:lower) } "
    css_classes << 'folded' unless resource.base?
    content_tag :li,
      render(:partial => '/shapes/resources/li_content', :locals => { :resource => resource }),
      :class => css_classes,
      :id => resource.base? ? 'baseUl' : li_css_id(resource.parent.path, counter),
      :path => resource.path
  end

  def ul_css_id(path)
    "#{ path_to_css_selector path }Ul"
  end

  def li_css_id(parent_path, counter)
    "#{ path_to_css_selector parent_path }Li_#{ counter }"
  end

end
