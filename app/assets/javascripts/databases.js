$(document).on('turbolinks:load', function(){
  $('.down').hide();
  $('div.databases_list').hide();
  var i = true;
  $('h3#lista_baz').click(function(){
    if(i == true){
      i = false;
      $('.down').show();
      $('.up').hide();
      $('div.databases_list').show();
    } else if(i == false){
      i = true;
      $('.down').hide();
      $('.up').show();
      $('div.databases_list').hide();
    }
  });
});
    