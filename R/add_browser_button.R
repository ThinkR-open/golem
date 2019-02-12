#' Insert an hidden browser button
#' 
#' See \url{https://rtask.thinkr.fr/blog/a-little-trick-for-debugging-shiny/} for more context.
#'
#' @return Prints the code to the console.
#' @export
#' 
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
  cat_line("By default, this button will be hidden.")
  cat_line("To show it, open your web browser JavaScript console")
  cat_line("And run $('#browser').show();")
}