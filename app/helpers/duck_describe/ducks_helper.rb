module DuckDescribe::DucksHelper  

  include DuckDescribe::DuckDescribeHelper

  def duck_form(duck, type, &block)
    path, method = (type == :edit) ? 
      [duck_path(duck), :put] : 
      [ducks_path, :post]
    form_for :duck, duck,
          :url => path,
          :html => {:method => method},
          &block
  end

end
