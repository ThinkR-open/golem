#' Insert an hidden browser button
#'
#' @return Prints the code to the console
#' @export
#' @importFrom cli cat_rule cat_line
add_browser_button <- function(){
  cat_rule("To be copied in your UI")
  cat_line('actionButton("browser", "browser"),')
  cat_line('tags$script("$(\'#browser\').hide();")')
  cat_line()
  cat_rule("To be copied in your server")
  cat_line('observeEvent(input$browser,{')
  cat_line('  browser()')
  cat_line('})')
  cat_line()
  cat_line("To show this button, open your web browser JavaScript console")
  cat_line("And run $('#browser').show();")
}