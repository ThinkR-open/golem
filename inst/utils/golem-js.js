$( document ).ready(function() {
      Shiny.addCustomMessageHandler('showid', function(what) {
    $("#" + what).show()
  });

  Shiny.addCustomMessageHandler('hideid', function(what) {
    $("#" + what).hide()
  });

  ('showclass', function(what) {
    $("." + what).show()
  });

  Shiny.addCustomMessageHandler('hideclass', function(what) {
    $("." + what).hide()
  });
  
  Shiny.addCustomMessageHandler('clickon', function(what) {
    $(what).click()
  });
});


