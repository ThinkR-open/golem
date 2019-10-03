#' Interact with JavaScript built-in Functions
#' 
#' \code{activate_js} is used in your UI to insert directly the JavaScript 
#' functions contained in golem. These functions can be called from 
#' the server with \code{invoke_js}. \code{invoke_js} can also be used 
#' to launch any JS function created inside a Shiny JavaScript handler. 
#' 
#' @param fun JS function to be invoked.
#' @param ui_ref The UI reference to call the JS function on.
#' @param session The shiny session within which to call \code{sendCustomMessage}.
#' 
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
#' @export
#' @rdname golem_js
#' @importFrom htmltools includeScript

activate_js <- function(){
  includeScript(
    system.file("utils/golem-js.js", package = "golem")
  )
}

#' @export
#' @rdname golem_js
invoke_js <- function( 
  fun, 
  ui_ref, 
  session = shiny::getDefaultReactiveDomain() 
){
  res <- mapply(function(x, y){
    session$sendCustomMessage(x, y)
  }, x = fun, y = ui_ref)
  invisible(res)
  #session$sendCustomMessage(fun, ui_ref)
}

