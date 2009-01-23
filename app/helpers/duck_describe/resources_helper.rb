module DuckDescribe::ResourcesHelper

  include DuckDescribe::DuckDescribeHelper

  def resource_form(duck, resource, type, &block)
    url = (type == :edit) ?
      update_resource_path(:id => duck.id, :path => resource.path) :
      create_resource_path(:id => duck.id, :parent_path => params[:parent_path])
    form_for :duck, duck,
          :url => url,
          :html => {:multipart => true},
          &block
  end

  def resource_type_select(resource_type_collection)
    select_tag :type,
      option_groups_from_collection_for_select(resource_type_collection, :options, :name, :name, :id)
  end
end
