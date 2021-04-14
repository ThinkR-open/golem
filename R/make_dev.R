#' Make a function dependent to dev mode
#' 
#' The function returned will be run only if `golem::app_dev()`
#'     returns TRUE.
#'
#' @param fun A function
#'
#' @export
#' 
#' @return Used for side-effects
make_dev <- function(fun){
  function(...){
    if ( golem::app_dev() ){
      fun(...)
    }
  }
}

`%||%` <- function(x, y){
  if (is.null(x)) y else x
}

#' Is the app in dev mode or prod mode?
#'
#' @return `TRUE` or `FALSE` depending on the status of `getOption( "golem.app.prod")`
#' @export
#'
#' @rdname prod
#' @return A boolean.
app_prod <- function(){
  getOption( "golem.app.prod" ) %||% FALSE
}

# Well, this one does the opposite 
#' @rdname prod
#' @export
app_dev <- function(){
  !golem::app_prod()
}

#' Functions already made dev dependent
#' 
#' This functions will be run only if `golem::app_dev()`
#'     returns TRUE.
#' @rdname made_dev
#' @inheritParams base::cat
#' @export 
#' @return A modified function.
cat_dev <- make_dev(base::cat)

#' @rdname made_dev
#' @export 
#' @inheritParams base::print
print_dev <- make_dev(base::print)

#' @rdname made_dev
#' @export 
#' @inheritParams base::message
message_dev <- make_dev(base::message)

#' @rdname made_dev
#' @export 
#' @inheritParams base::warning 
warning_dev <- make_dev(base::warning )

#' @rdname made_dev
#' @export 
#' @inheritParams base::browser 
browser_dev <- make_dev(base::browser )

