module Shapes::CommonHelper

  def path_to_css_selector(path)
    #need underscores in selector to ensure uniqueness of css id
    path.split(/#/).delete_if { |x| x.blank? }.collect {|x| x.camelize(:lower) } * '_'
  end

  def link_to_show_constraints(resource)
    unless resource.applicable_constraints.empty?
      link_to 'Show constraints', show_constraints_path(:id => resource.base.shape_id, :path => resource.path)
    end
  end

end
