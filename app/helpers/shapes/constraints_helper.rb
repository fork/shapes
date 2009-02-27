module Shapes::ConstraintsHelper

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
          :html => {:multipart => true},
          &block
  end
  
  def struct_constraint_form(struct_primitive, type, &block)
    url = (type == :edit) ?
      update_struct_constraint_path(:id => struct_primitive.id) :
      create_struct_constraint_path(:id => struct_primitive.id)
    form_for :struct_primitive, struct_primitive,
          :url => url,
          :html => {:multipart => true},
          &block
  end
  
  def link_to_add_constraint(shape, resource)
    return if(resource.left_constraints.empty?)
    link_to 'Add constraint', select_constraint_path(shape, resource.path)
  end

  def link_to_add_struct_constraint(struct_primitive, resource)
    return if(resource.left_constraints.empty?)
    link_to 'Add constraint', select_struct_constraint_path(struct_primitive, struct_primitive.primitive)
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
      name + check_box_tag("constraint[types][]", type, @constraint.types.include?(type))
  end
end
