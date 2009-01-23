with_options :controller => 'duck_describe/resources' do |resources|
  resources.new_resource    'duck_describe/ducks/:id/new_resource/:parent_path',    :action => 'new'
  resources.create_resource 'duck_describe/ducks/:id/create_resource/:parent_path', :action => 'create'
  resources.select_resource 'duck_describe/ducks/:id/select/:parent_path',          :action => 'select'
  resources.edit_resource   'duck_describe/ducks/:id/edit_resource/:path',          :action => 'edit'
  resources.update_resource 'duck_describe/ducks/:id/update_resource/:path',        :action => 'update'
  resources.delete_resource 'duck_describe/ducks/:id/delete_resource/:path',        :action => 'delete'
end

resources :ducks,
  :controller => 'duck_describe/ducks',
  :path_prefix => '/duck_describe' do |duck|
  duck.resources :duck_struct,
    :controller => 'duck_describe/duck_structs'
end

resources :duck_structs,
  :path_prefix => '/duck_describe',
  :controller => 'duck_describe/duck_structs' do |duck_structs|
  duck_structs.resources :duck_struct_primitives,
    :controller => 'duck_describe/duck_struct_primitives'
end

connect 'duck_describe/xml/:ident.:format',
  :controller => 'duck_describe/ducks', :action => 'xml'
