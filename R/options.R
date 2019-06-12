#' {golem} options
#' 
#' Set a series of options to be used internally by {golem}.
#' 
#' @param pkg_name Name of the current golem.
#' @param pkg_version Version of the current golem.
#' @param pkg_path Name of the current golem.
#' @param app_prod Is the {golem} in prod mode?
#'
#' @export
set_golem_options <- function(
  pkg_name = pkgload::pkg_name(), 
  pkg_version = pkgload::pkg_version(), 
  pkg_path = pkgload::pkg_path(),
  app_prod = FALSE
){
  cli::cat_rule("Setting {golem} options")
  options("golem.pkg.name" = pkg_name)
  cat_green_tick(sprintf("Setting options('golem.pkg.name') to %s", pkg_name))
  options("golem.pkg.version" = pkg_version)
  cat_green_tick(sprintf("Setting options('golem.pkg.version') to %s", pkg_version))
  options("golem.pkg.path" = pkg_path)
  cat_green_tick(sprintf("Setting options('golem.pkg.path') to %s", pkg_path))
  options("golem.app.prod" = app_prod)
  cat_green_tick(sprintf("Setting options('golem.app.prod') to %s", app_prod))
}