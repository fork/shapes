ActionController::Routing::Routes.draw do |map|
  map.connect '/shapes', :controller => 'shapes/shapes'

  map.with_options :controller => 'shapes/resources' do |resource|
    resource.new_resource    'shapes/:id/new_resource/:parent_path',    :action => 'new'
    resource.create_resource 'shapes/:id/create_resource/:parent_path', :action => 'create'
    resource.select_resource 'shapes/:id/select/:parent_path',          :action => 'select'
    resource.unfold_resource 'shapes/:id/unfold/:path',                 :action => 'unfold'
    resource.edit_resource   'shapes/:id/edit_resource/:path',          :action => 'edit'
    resource.render_resource 'shapes/:id/render_resource/:path',        :action => 'render_resource'
    resource.resource_delete_confirmation 'shapes/:id/delete_confirmation/:path',:action => 'delete_confirmation'
    resource.update_resource 'shapes/:id/update_resource/:path',        :action => 'update'
    resource.delete_resource 'shapes/:id/delete_resource/:path',        :action => 'delete'
  end

  map.with_options :controller => 'shapes/constraints' do |constraint|
    constraint.show_constraints         'shapes/:id/show_constraints/:path',          :action => 'show'
    constraint.select_constraint        'shapes/:id/select_constraint/:path',         :action => 'select'
    constraint.new_constraint           'shapes/:id/new_constraint/:path',            :action => 'new'
    constraint.create_constraint        'shapes/:id/create_constraint/:path/',        :action => 'create'
    constraint.edit_constraint          'shapes/:id/edit_constraint/:path',           :action => 'edit'
    constraint.update_constraint        'shapes/:id/update_constraint/:path',         :action => 'update'
    constraint.delete_constraint        'shapes/:id/delete_constraint/:path/:type',   :action => 'delete'
  end

  map.resources :shapes,
    :controller => 'shapes/shapes',
    :path_prefix => '/shapes' do |shape|
    shape.resources :shape_struct,
      :controller => 'shapes/structs'
  end

  map.clone_shape 'shapes/:id/clone_shape',
    :controller => 'shapes/shapes',
    :action => 'clone'
  map.dup_shape 'shapes/:id/dup_shape',
    :controller => 'shapes/shapes',
    :action => 'dup'

  map.resources :shape_structs,
    :path_prefix => '/shapes',
    :controller => 'shapes/structs' do |shape_structs|
      shape_structs.resources :shape_struct_primitives,
        :controller => 'shapes/struct_primitives'
  end

  map.connect 'shapes/cache/*path',
    :controller => 'shapes/shapes', :action => 'cache'
end
