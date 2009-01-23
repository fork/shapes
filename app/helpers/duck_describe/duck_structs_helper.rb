module DuckDescribe::DuckStructsHelper

  include DuckDescribe::DuckDescribeHelper

  def duck_struct_form(duck_struct, type, &block)
    path, method = (type == :edit) ? 
      [duck_struct_path(duck_struct), :put] : 
      [duck_structs_path, :post]
    form_for :duck_struct, duck_struct,
          :url => path,
          :html => {:method => method},
          &block
  end

end
