# after_creation_msg works

    Code
      after_creation_message_generic("mypkg", "inst/app/www", "myjs")
    Output
      * File myjs created
    Code
      after_creation_message_js("mypkg", "inst/app/www", "myjs")
      after_creation_message_css("mypkg", "inst/app/www", "mycss")
      after_creation_message_sass("mypkg", "inst/app/www", "mysass")
      after_creation_message_html_template("mypkg", "inst/app/www", "myhtml")
    Output
      
      To use this html file as a template, add the following code in your UI:
      htmlTemplate(
          app_sys("app/www/myhtml.html"),
          body = tagList()
          # add here other template arguments
      )
    Code
      file_created_dance("inst/app/www", after_creation_message_sass, "mypkg",
        "inst/app/www", "mysass", open_file = FALSE, open_or_go_to = FALSE)
    Output
      v File created at inst/app/www

