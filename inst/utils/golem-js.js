$( document ).ready(function() {
  Shiny.addCustomMessageHandler('show', function(what) {
    $(what).show();
  });

  Shiny.addCustomMessageHandler('hide', function(what) {
    $(what).hide();
  });
  
  Shiny.addCustomMessageHandler('showid', function(what) {
    $("#" + what).show();
  });

  Shiny.addCustomMessageHandler('hideid', function(what) {
    $("#" + what).hide();
  });

  Shiny.addCustomMessageHandler('showclass', function(what) {
    $("." + what).show();
  });

  Shiny.addCustomMessageHandler('hideclass', function(what) {
    $("." + what).hide();
  });
  
  Shiny.addCustomMessageHandler('showhref', function(what) {
    $("a[href*=" + what).show();
  });

  Shiny.addCustomMessageHandler('hidehref', function(what) {
    $("a[href*=" + what).hide();
  });
  
  Shiny.addCustomMessageHandler('clickon', function(what) {
    $(what).click();
  });
  
  Shiny.addCustomMessageHandler('disable', function(what) {
    $(what).attr('disabled', 'disabled');
  });
  
  Shiny.addCustomMessageHandler('reable', function(what) {
    $(what).removeAttr('disabled');
  });
  
  Shiny.addCustomMessageHandler('alert', function(message) {
    alert(message);
  });
  
  Shiny.addCustomMessageHandler('prompt', function(args) {
    var input = prompt(args.message);
    Shiny.setInputValue(args.id, input);
    return input;
  });
  
  Shiny.addCustomMessageHandler('confirm', function(args) {
    var input = confirm(args.message);
    Shiny.setInputValue(args.id, input);
    return input;
  });
  
});


