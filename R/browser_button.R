#' Insert an hidden browser button
#' 
#' See \url{https://rtask.thinkr.fr/a-little-trick-for-debugging-shiny/} for more context.
#'
#' @return Prints the code to the console.
#' @export
#' 
#' @importFrom cli cat_rule cat_line
browser_button <- function(){
  cat_rule("To be copied in your UI")
  cat_line(darkgrey('actionButton("browser", "browser"),'))
  cat_line(darkgrey('tags$script("$(\'#browser\').hide();")'))
  cat_line()
  cat_rule("To be copied in your server")
  cat_line(darkgrey('observeEvent(input$browser,{'))
  cat_line(darkgrey('  browser()'))
  cat_line(darkgrey('})'))
  cat_line()
  cat_line("By default, this button will be hidden.")
  cat_line("To show it, open your web browser JavaScript console")
  cat_line("And run $('#browser').show();")
}

