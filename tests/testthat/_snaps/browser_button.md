# browser_button works

    Code
      browser_button()
    Condition
      Warning in `browser_button()`:
      browser_button() is currently soft deprecated and will be removed in future versions of {golem}.
    Output
      -- To be copied in your UI -----------------------------------------------------
      actionButton("browser", "browser"),
      tags$script("$('#browser').hide();")
      
      -- To be copied in your server -------------------------------------------------
      observeEvent(input$browser,{
        browser()
      })
      
      By default, this button will be hidden.
      To show it, open your web browser JavaScript console
      And run $('#browser').show();
