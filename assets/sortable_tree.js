if(Prototype){

  var ShapesSortableTree = {
    extendList: function(){
      $$('ul.shapesSortableList').each(function(ul) {
        ShapesSortableTree.extendUl(ul);
        ShapesSortableTree.generateSortableScript(ul);
      });
    },    
    extendUl: function(ul){
      //fetch only direct child nodes
      sortableLiArray = $$('ul#' + ul.id + ' > li.shapesResource')
      if(sortableLiArray.size() > 1) {
        sortableLiArray.each(function(obj, index) {
          ShapesSortableTree.extendLi(obj, index, ul);
        });
      }
    },    
    extendLi: function(li, index, ul){
      li.setAttribute('id', ul.id + '_' + index);
      li.addClassName('sortable');
      ShapesSortableTree.appendSortableAnchor(li);
    },    
    appendSortableAnchor: function(li){
      handle = new Element('a', { href: '#', class: 'handle', style: 'cursor:move;' }).update("Sort");
      Element.insert(li.down('a', 0), { 'before': handle })
    },
    generateSortableScript: function(ul){
      Sortable.create(ul.id , {onUpdate:function(){
        new Ajax.Request('/shapes/resources/reorder_resource_with_prototype', {handle:'handle', only: 'sortable', asynchronous:true, evalScripts:true, onComplete:function(request){
            new Effect.Highlight(ul.id,{});}, parameters:Sortable.serialize(ul.id) + '&path=' + escape(ul.readAttribute('path')) + '&shape_id=' + $$('ul[shapeId]').first().readAttribute('shapeId')})
        }
      });
    }
  }
  
  ShapesSortableTree.extendList();
}



