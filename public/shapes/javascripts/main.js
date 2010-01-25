var Shapes = {
  id: function(){
   return $('shapeUl').readAttribute('shape_id');
  },
  path: function(){
   return $('shapeUl').readAttribute('path');
  },
  toggleArrayContent: function(id, path) {
    parent_li = $(id).up('li');
    if($(id).childElements().length > 0){
      //fold/remove all child elements
      $(id).update('');
      parent_li.removeClassName('unfolded');
      parent_li.addClassName('folded');
    } else {
      new Ajax.Updater(id, '/shapes/' + Shapes.id() + '/unfold/' + escape(path), { 
        method: 'get',
        evalScripts: true,
        onComplete:function(request){
          parent_li.removeClassName('folded');
          parent_li.addClassName('unfolded');
          ShapesSortableUl.createSortable(id, path);
        }
      });
    }
  },
  //insert iFrame, change form target, onsubmit and enctype
  prepareFormForAjaxUpload: function(){
    form = $('resourceform');
    css_id = form.up('li').readAttribute('id');
    form.writeAttribute('action', form.readAttribute('action') + '?css_id=' + css_id );
    form.writeAttribute('onsubmit', '');
    form.writeAttribute('enctype', 'multipart/form-data');
    form.insert({
      bottom: new Element('iframe', { name: 'uploadtarget', id: 'uploadtarget', src: '#' })
    });
    form.writeAttribute('target', 'uploadtarget');
  },
  //close all other "property changers" e.g. forms
  closeAllPropertyChangers: function(){
    $$('.propertyChanger').each(function(obj) {
      obj.removeClassName('propertyChanger');
      render_resource_path = '/shapes/' + Shapes.id() + '/render_resource/' + escape(obj.readAttribute('path'));
      new Ajax.Updater(obj.id, render_resource_path, { method: 'get' });
    });
    return true;
  },
  openPropertyChanger: function(element){
    if(Shapes.closeAllPropertyChangers()){
      element.addClassName('propertyChanger');
    }
  },
  //renders an url in an element, changes folded/unfolded status
  renderUrlInElement: function(element, url){
    new Ajax.Updater(element.id, url, {
      method: 'get', 
      parameters: {},
      evalScripts: true,
      onSuccess: function(request){ 
        if(element.hasClassName('unfolded')){
          element.removeClassName('unfolded');
          element.addClassName('folded');
        }
      }
    });
  },
  remoteForm: function(element, form, url){
    new Ajax.Updater(element.id, url, 
      { asynchronous: true, 
        evalScripts: true, 
        parameters: Form.serialize(form),
        onSuccess: function(request){
          Shapes.remoteFormOnSuccess(element);
        }
      });
  },
  remoteFormOnSuccess: function(li){
    new Effect.Highlight(li.id, {});
  },
  parentLiFor: function(element){
    element = Element.extend(element);
    return element.up('li') || element;
  },
  deleteResourceLink: function(element, url){
    li = Shapes.parentLiFor(element)
    new Ajax.Updater(li.id, url, { asynchronous:true, 
      evalScripts: true, 
      onComplete: function(request){ li.remove(); }
    });
  },
  renderResource:function(li){
    Shapes.render_resource_path(li, li.readAttribute('path'));
  },
  renderResource:function(li, path){
    render_resource_path = '/shapes/' + Shapes.id() + '/render_resource/' + escape(path);
    new Ajax.Updater(li.id, render_resource_path, {
      method: 'get',
      evalScripts: true,
      onSuccess: function(request){
        new Effect.Highlight(li.id, {});
      }
    });
  },
  openFormForBaseElement:function(path){
    if($('baseUl').down('li')){
      Shapes.openPropertyChanger($('baseUl').down('li')); 
      Shapes.renderUrlInElement($('baseUl').down('li'), path);
    }
  }
}

/** Sortable list **/
var ShapesSortableUl = {
  createSortable: function(ul_id, path){
    Sortable.create(ul_id , { handle: 'handle',
      onUpdate: function(){
        new Ajax.Request('/shapes/resources/reorder_resource_with_prototype', {
          only: 'sortable', 
          asynchronous: true, 
          evalScripts: true, 
          onComplete: function(request){
            ShapesSortableUl.reordertId(ul_id);
            new Effect.Highlight(ul_id, {});
          },
          parameters: Sortable.serialize(ul_id) + '&path=' + escape(path) + '&shape_id=' + Shapes.id() 
        })
      }
    });
  },
  reordertId: function(ul_id){
    sortableLiArray = $$('ul#' + ul_id + ' > li.shapesResource')
    if(sortableLiArray.size() > 1) {
      sortableLiArray.each(function(obj, index) {
        obj.setAttribute('id', ul_id.gsub('Ul', 'Li') + '_' + index);
      });
    }
  }
}
