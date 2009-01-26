with_options :controller => 'shapes/resources' do |resources|
  resources.new_resource    'shapes/:id/new_resource/:parent_path',    :action => 'new'
  resources.create_resource 'shapes/:id/create_resource/:parent_path', :action => 'create'
  resources.select_resource 'shapes/:id/select/:parent_path',          :action => 'select'
  resources.edit_resource   'shapes/:id/edit_resource/:path',          :action => 'edit'
  resources.update_resource 'shapes/:id/update_resource/:path',        :action => 'update'
  resources.delete_resource 'shapes/:id/delete_resource/:path',        :action => 'delete'
end

resources :shapes,
  :controller => 'shapes/shapes',
  :path_prefix => '/shapes' do |shape|
  shape.resources :shape_struct,
    :controller => 'shapes/structs'
end

resources :shape_structs,
  :path_prefix => '/shapes',
  :controller => 'shapes/structs' do |shape_structs|
    shape_structs.resources :shape_struct_primitives,
      :controller => 'shapes/struct_primitives'
end

connect 'shapes/xml/:ident.:format',
  :controller => 'shapes/shapes', :action => 'xml'
