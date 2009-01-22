module DuckDescribe::DuckStructPrimitivesHelper
    
  def duck_struct_primitive_form(duck_struct_primitive, type, &block)
    path, method = (type == :edit) ? 
      [duck_struct_duck_struct_primitive_path(duck_struct_primitive.duck_struct, duck_struct_primitive), :put] : 
      [duck_struct_duck_struct_primitives_path(duck_struct_primitive.duck_struct.id), :post]
    form_for :duck_struct_primitive, duck_struct_primitive,
          :url => path,
          :html => {:method => method},
          &block
  end

end
