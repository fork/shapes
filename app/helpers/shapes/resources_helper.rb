module Shapes::ResourcesHelper

  include Shapes::CommonHelper

  def resource_form(shape, resource, type, &block)
    url = (type == :edit) ?
      update_resource_path(:id => shape.id, :path => resource.path) :
      create_resource_path(:id => shape.id, :parent_path => params[:parent_path])
    form_for :shape, shape,
          :url => url,
          :html => { :name => 'resourceform', :id => 'resourceform', :onsubmit => "Shapes.remoteForm(Shapes.parentLiFor(this), this, '#{ url }'); return false;" },
          &block
  end

  def resource_type_select(resource_type_collection)
    select_tag :type,
      option_groups_from_collection_for_select(resource_type_collection, :options, :name, :name, :id)
  end

  def link_to_confirm_delete_resource(params)
    link_to '', '#', 
      { :onclick => "Shapes.deleteResourceLink(this, '#{ delete_resource_path(:id => params[:id], :path => params[:path]) }'); return false;", 
        :title => 'Confirm', 
        :class => 'icon confirm' }
  end

  def link_to_cancel_delete_resource
    link_to '', '#', 
      { :onclick => "Shapes.renderResource(Shapes.parentLiFor(this)); return false;", 
        :title => 'Cancel', 
        :class => 'icon cancel' }
  end

end
