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

  def link_to_delete_struct(struct)
    link_to '', shape_struct_path(struct), 
      { :method => :delete, 
        :class => 'icon delete', 
        :title => 'Delete struct', 
        :confirm => 'Are you sure?' }
  end
  
  def link_to_edit_struct(struct)
    link_to '', shape_struct_path(struct), 
      { :class => 'icon edit', 
        :title => 'Edit struct' }
  end

  def link_to_delete_shape_struct_primitive(primitive)
    link_to '', 
      shape_struct_shape_struct_primitive_path(primitive.shape_struct, primitive),
      { :method => :delete, 
        :class => 'icon delete', 
        :title => 'Delete primitive',
        :confirm => 'Are you sure?' }
  end

end
