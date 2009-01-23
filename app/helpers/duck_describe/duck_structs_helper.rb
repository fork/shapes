module DuckDescribe::DuckStructsHelper

  include DuckDescribe::DuckDescribeHelper

  def duck_struct_form(duck_struct, type, &block)
    if @duck
      path, method = (type == :edit) ?
        [duck_duck_struct_path(:duck => @duck, :duck_struct => duck_struct), :put] :
        [duck_duck_struct_index_path(@duck), :post]
    else
      path, method = (type == :edit) ?
        [duck_struct_path(duck_struct), :put] :
        [duck_structs_path, :post]
    end
    form_for :duck_struct, duck_struct,
          :url => path,
          :html => {:method => method},
          &block
  end

end
