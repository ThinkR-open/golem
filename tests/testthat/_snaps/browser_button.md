# browser_button works

    Code
      browser_button()
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

