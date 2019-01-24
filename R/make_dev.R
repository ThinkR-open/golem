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

#' Is the app in dev mode or prof mode?
#'
#' @return `TRUE` or `FALSE` depending on the status of `getOption( "golem.app.prod")`
#' @export
#'
#' @rdname prod

app_prod <- function(){
  getOption( "golem.app.prod") %||% FALSE
}

# Well, this one does the opposite ¯\_(ツ)_/¯ 
#' @rdname prod
#' @export
app_dev <- function(){
  !app_prod()
}

#' Run cat when in dev mode
#'
#' @export 
cat_dev <- make_dev(cat)

