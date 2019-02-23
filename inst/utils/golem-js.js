$( document ).ready(function() {
  Shiny.addCustomMessageHandler('showid', function(what) {
    $("#" + what).show()
  });

  Shiny.addCustomMessageHandler('hideid', function(what) {
    $("#" + what).hide()
  });

  Shiny.addCustomMessageHandler('showclass', function(what) {
    $("." + what).show()
  });

  Shiny.addCustomMessageHandler('hideclass', function(what) {
    $("." + what).hide()
  });
  
  Shiny.addCustomMessageHandler('showhref', function(what) {
    $("a[href*=" + what).show()
  });

  Shiny.addCustomMessageHandler('hidehref', function(what) {
    $("a[href*=" + what).hide()
  });
  
  Shiny.addCustomMessageHandler('clickon', function(what) {
    $(what).click()
  });
  
    
  Shiny.addCustomMessageHandler('disable', function(what) {
    $(what).attr('disabled', 'disabled')
  });
  
  Shiny.addCustomMessageHandler('reable', function(what) {
    $(what).removeAttr('disabled')
  });
  
});


