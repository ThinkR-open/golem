`%||%` <- function(x, y){
  if (is.null(x)) y else x
}

#' return `TRUE` if in `production mode`
app_prod <- function(){
  getOption( "golem.app.prod") %||% FALSE
}

app_dev <- function(){
  !app_prod()
}



