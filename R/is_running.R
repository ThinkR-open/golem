#' Is the running app a golem app?
#'
#' Note that this will return `TRUE` only if the application
#' has been launched with `with_golem_options()`
#'
#' @return TRUE if the running app is a `{golem}` based app,
#' FALSE otherwise.
#' @export
#'
#' @examples
#' is_running()
is_running <- function() {
	.golem_globals$running
}
