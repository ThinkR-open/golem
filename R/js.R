#' Add JS code Straight to your app (instead of a dependency)
#' 
#' This function can be used in your UI to insert directly the JavaScript 
#' functions contained in golem.
#' 
#' @details These functions are meant to be used with `session$sendCustomMessage` 
#'     from the server side. 
#' 
#' \describe{
#'   \item{show}{Show an element with the jQuery selector provided.}
#'   \item{hide}{Hide an element with the jQuery selector provided.}
#'   \item{showid}{Show an element with the id provided.}
#'   \item{hideid}{Hide an element with the id provided.}
#'   \item{showclass}{Same as showid, but with class.}
#'   \item{hideclass}{Same as hideid, but with class.}
#'   \item{showhref}{Same as showid, but with `a[href*=`}
#'   \item{hidehref}{Same as hideid, but with `a[href*=`}
#'   \item{clickon}{Click on an element. The full jQuery selector has to be used.}
#'   \item{disable}{Add "disabled" to an element. The full jQuery selector has to be used.}
#'   \item{reable}{Remove "disabled" from an element. The full jQuery selector has to be used.}
#' }
#'
#' @return A script
#' @export
#' @importFrom htmltools includeScript

js <- function(){
  includeScript(
    system.file("utils/golem-js.js", package = "golem")
  )
}