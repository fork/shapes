module Shapes::ShapesHelper

  include Shapes::CommonHelper

  def shape_form(shape, type, &block)
    path, method = (type == :edit) ?
      [shape_path(shape), :put] :
      [shapes_path, :post]
    form_for :shape, shape,
          :url => path,
          :html => {:method => method},
          &block
  end

  def link_to_show_shape(shape)
    link_to '', shape_path(shape), 
      { :onclick => "new Ajax.Updater('content', '#{ shape_path(shape) }', { method: 'get', evalScripts: true } ); return false;", 
        :class => 'icon show', 
        :title => 'Show shape' }
  end

  def link_to_delete_shape(shape)
    link_to '', shape_path(shape), 
      { :method => :delete, 
        :class => 'icon delete', 
        :title => 'Delete shape', 
        :confirm => 'Are you sure?' }
  end
  
  def link_to_edit_shape(shape)
    link_to '', edit_shape_path(shape), 
      { :class => 'icon edit', 
        :title => 'Edit shape' }
  end
  
  def shape_ul(shape)
    content_tag :ul, :shape_id => shape.id, :id => 'shapeUl' do
      content_tag :li, :id => 'shapeli' do
        content_tag :ul, :id => 'baseUl' do
          render :partial => "/shapes/resources/li", :collection => [ shape.base ], :as => :resource
        end 
      end
    end
  end

end
