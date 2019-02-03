$(document).on('shiny:sessioninitialized', function(event) {
  
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
  
  Shiny.addCustomMessageHandler('clickon', function(what) {
    console.log(what)
    $(what).click()
  });
);

