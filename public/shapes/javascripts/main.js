function toggleArrayContent(id, shape_id, path) {
  if($(id).childElements().length > 0){
    //fold/remove all child elements
    $(id).update('');

  } else {
    new Ajax.Updater(id, '/shapes/' + shape_id + '/unfold/' + escape(path), { method: 'get' });
  }
}
