#' Add JS Straight to your app (instead of a dependency)
#'
#' @return A script
#' @export

js <- function(){
  htmltools::includeScript(
    system.file("utils/golem-js.js", package = "golem")
  )
}