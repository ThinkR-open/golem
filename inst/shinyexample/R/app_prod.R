`%||%` <- function (x, y)
{
  if (is.null(x))
    y
  else x
}
#' return `TRUE` if in `production mode`
app_prod <- function(){
  getOption( "app.prod" ) %||% TRUE
}
