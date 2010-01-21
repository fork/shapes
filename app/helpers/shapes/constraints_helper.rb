module Shapes::ConstraintsHelper

  include Shapes::CommonHelper

  def primitive_checkbox_array
    content_tag :ul, primitive_checkboxes
  end

  def local_structs_checkbox_array
    content_tag :ul, local_struct_checkboxes
  end

  def global_structs_checkbox_array
    content_tag :ul, global_struct_checkboxes
  end

  def constraint_form(shape, resource, type, &block)
    url = (type == :edit) ?
      update_constraint_path(:id => shape.id, :path => resource.path) :
      create_constraint_path(:id => shape.id, :path => resource.path)
    form_for :shape, shape,
          :url => url,
          :html => { :onsubmit => "Shapes.remoteForm(Shapes.parentLiFor(this), this, '#{ url }'); return false;", :multipart => true },
          &block
  end

  def link_to_add_constraint(shape, resource)
    return if(resource.left_constraints.empty?)
    select_path = select_constraint_path(shape, resource.path)
    link_to 'Add constraint', select_path, 
      { :onclick => "Shapes.openPropertyChanger(Shapes.parentLiFor(this)); Shapes.renderUrlInElement(Shapes.parentLiFor(this), '#{ select_path }'); return false;" }
  end

  protected

  def primitive_checkboxes
    Shapes::Primitive.primitives.collect do |primitive|
      checkbox_li primitive.name.demodulize, "Primitive-#{primitive.name.demodulize}"
    end
  end

  def local_struct_checkboxes
    @shape.local_structs.collect do |struct|
      checkbox_li struct.name.demodulize, "Struct-#{struct.name.demodulize}"
    end
  end

  def global_struct_checkboxes
    ShapeStruct.global.collect do |struct|
      checkbox_li struct.name.demodulize, "Struct-#{struct.name.demodulize}"
    end
  end

  def checkbox_li(name, type)
    content_tag :li,
      check_box_tag("constraint[types][]", type, @constraint.types.include?(type)) + " #{ name }"
  end

end
