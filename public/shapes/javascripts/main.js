var Shapes = {
  id: function(){
   return $$('ul.shapesBase').first().readAttribute('shapeId');
  },
  toggleArrayContent: function(id, shape_id, path) {
    if($(id).childElements().length > 0){
      //fold/remove all child elements
      $(id).update('');
    } else {
      new Ajax.Updater(id, '/shapes/' + shape_id + '/unfold/' + escape(path), { 
        method: 'get',
        onComplete:function(request){
          ShapesSortableUl.createSortable(id, shape_id, path);
        }
      });
    }
  },
  //insert iFrame and change form target
  prepareFormForAjaxUpload: function(){
    $('resourceform').insert({
      bottom: new Element('iframe', { name: 'uploadtarget', id: 'uploadtarget', src: '#', style: 'width:0;height:0;border:0px solid #fff;' })
    });
    $('resourceform').writeAttribute('target', 'uploadtarget');
    $('resourceform').writeAttribute('onsubmit', '');
    $('resourceform').writeAttribute('enctype', 'multipart/form-data');
  },
  //close all other "property changers" e.g. forms
  closePropertyChangers: function(){
    $$('.propertyChanger').each(function(obj) {
      obj.removeClassName('propertyChanger');
      render_resource_path = '/shapes/' + Shapes.id() + '/render_resource/' + escape(obj.readAttribute('path'));
      new Ajax.Updater(obj.id, render_resource_path, { method: 'get' });
    });
    return true;
  },
  renderUrlInElement: function(element, url){
    li = Shapes.parentLiFor(element)
    if(Shapes.closePropertyChangers()){
      new Ajax.Updater(li.id, url, {
        method: 'get', 
        parameters: {},
        evalScripts: true,
        onSuccess: function(request){ li.addClassName('propertyChanger'); }
      });
    }
  },
  remoteForm: function(element, url){
    li = Shapes.parentLiFor(element);    
    new Ajax.Updater(li.id, url, 
      { asynchronous:true, 
        evalScripts:true, 
        parameters:Form.serialize(element) } );
  },
  parentLiFor: function(element){
    return Element.extend(element).up('li');
  },
  // Resources
  deleteResourceLink: function(element, url){
    li = Shapes.parentLiFor(element)
    new Ajax.Updater(li.id, url, { asynchronous:true, 
      evalScripts:true, 
      onComplete:function(request){ li.remove(); }
    });
  },
  renderResource:function(li){
    render_resource_path = '/shapes/' + Shapes.id() + '/render_resource/' + escape(li.readAttribute('path'));
    new Ajax.Updater(li.id, render_resource_path, { 
      method: 'get', 
      onSuccess: function(request){ li.removeClassName('propertyChanger'); }
    });
  }

}


/** Sortable list **/
var ShapesSortableUl = {
  createSortable: function(ul_id, shape_id, path){
      Sortable.create(ul_id , {onUpdate:function(){
        new Ajax.Request('/shapes/resources/reorder_resource_with_prototype', {handle:'handle', only: 'sortable', asynchronous:true, evalScripts:true, onComplete:function(request){
            new Effect.Highlight(ul_id,{});
            ShapesSortableUl.reordertId(ul_id);
            }, parameters:Sortable.serialize(ul_id) + '&path=' + escape(path) + '&shape_id=' + shape_id})
        }
    });
  },
  reordertId: function(ul_id){
    sortableLiArray = $$('ul#' + ul_id + ' > li.shapesResource')
    if(sortableLiArray.size() > 1) {
      sortableLiArray.each(function(obj, index) {
        ShapesSortableUl.changeLiClass(obj, index, ul_id);
      });
    }
  },
  changeLiClass: function(li, index, ul_id){
      li.setAttribute('id', ul_id + '_' + index);
  }
}
