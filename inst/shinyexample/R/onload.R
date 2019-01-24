#' Adds the content of www to www/ from this package
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
.onLoad <- function(...) {
  shiny::addResourcePath('www', system.file('app/www', package = 'shinyexample'))
}
