ActionController::Routing::Routes.draw do |map|
  map.connect '/shapes', :controller => 'shapes/shapes'

  map.with_options :controller => 'shapes/resources' do |resource|
    resource.new_resource    'shapes/:id/new_resource/:parent_path',    :action => 'new'
    resource.create_resource 'shapes/:id/create_resource/:parent_path', :action => 'create'
    resource.select_resource 'shapes/:id/select/:parent_path',          :action => 'select'
    resource.edit_resource   'shapes/:id/edit_resource/:path',          :action => 'edit'
    resource.update_resource 'shapes/:id/update_resource/:path',        :action => 'update'
    resource.delete_resource 'shapes/:id/delete_resource/:path',        :action => 'delete'
  end

  map.with_options :controller => 'shapes/constraints' do |constraint|
    constraint.show_constraints         'shapes/:id/show_constraints/:path',          :action => 'show'
    constraint.select_constraint        'shapes/:id/select_constraint/:path',         :action => 'select'
    constraint.new_constraint           'shapes/:id/new_constraint/:path',            :action => 'new'
    constraint.create_constraint        'shapes/:id/create_constraint/:path/',        :action => 'create'
    constraint.edit_constraint          'shapes/:id/edit_constraint/:path/:type',     :action => 'edit'
    constraint.update_constraint        'shapes/:id/update_constraint/:path',         :action => 'update'
    constraint.delete_constraint        'shapes/:id/delete_constraint/:path/:type',   :action => 'delete'
    constraint.show_struct_constraints  'shapes/show_struct_constraints/:id',         :action => 'show_struct_primitive'
    constraint.select_struct_constraint 'shapes/select_struct_constraint/:id/:path',  :action => 'select_struct_primitive'
    constraint.new_struct_constraint    'shapes/new_struct_constraint/:id',           :action => 'new_struct_primitive'
    constraint.update_struct_constraint 'shapes/update_struct_constraint/:id',        :action => 'update_struct_primitive'
    constraint.create_struct_constraint 'shapes/create_struct_constraint/:id',        :action => 'create_struct_primitive'
    constraint.delete_struct_constraint 'shapes/delete_struct_constraint/:id/:type',  :action => 'delete_struct_primitive'
    constraint.edit_struct_constraint   'shapes/edit_struct_constraint/:id/:type',    :action => 'edit_struct_primitive'
  end

  map.resources :shapes,
    :controller => 'shapes/shapes',
    :path_prefix => '/shapes' do |shape|
    shape.resources :shape_struct,
      :controller => 'shapes/structs'
  end

  map.resources :shape_structs,
    :path_prefix => '/shapes',
    :controller => 'shapes/structs' do |shape_structs|
      shape_structs.resources :shape_struct_primitives,
        :controller => 'shapes/struct_primitives'
  end

  map.connect 'shapes/xml/*path',
    :controller => 'shapes/shapes', :action => 'xml'
end
