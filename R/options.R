#' {golem} options
#' 
#' Set a series of options to be used internally by `{golem}`.
#' 
#' @param golem_name Name of the current golem.
#' @param golem_version Version of the current golem.
#' @param golem_wd Working directory of the current golem package.
#' @param app_prod Is the `{golem}` in prod mode?
#'
#' @export
set_golem_options <- function(
  golem_name = pkgload::pkg_name(), 
  golem_version = pkgload::pkg_version(), 
  golem_wd = pkgload::pkg_path(),
  app_prod = FALSE
){
  cli::cat_rule("Setting {golem} options")
  options("golem.pkg.name" = golem_name)
  cat_green_tick(sprintf("Setting options('golem.pkg.name') to %s", golem_name))
  options("golem.pkg.version" = golem_version)
  cat_green_tick(sprintf("Setting options('golem.pkg.version') to %s", golem_version))
  set_golem_wd(golem_wd, FALSE)
  cat_green_tick(sprintf("Setting options('golem.wd') to %s", golem_wd))
  cat_line("You can change golem working directory with set_golem_wd('path/to/wd')")
  options("golem.app.prod" = app_prod)
  cat_green_tick(sprintf("Setting options('golem.app.prod') to %s", app_prod))
}

#' Get and set `{golem}` working directory
#' 
#' Many `{golem}` functions rely on a specific working directory, 
#' most of the time the root of the package. This working directory 
#' is set by `set_golem_options` or the first time you create a file. 
#' It default to `"."`, the current directory when starting a golem. 
#' You can use these two functions if you need to manipulate this 
#' directory.
#' 
#' @param path The path to set the golem woking directory. 
#'     Note that it will be passed to `normalizePath`.
#' @param talkative Should the function print where the 
#'     new path is defined?
#'
#' @return The path to the working directory. 
#' @export
#' @rdname golem_wd
get_golem_wd <- function(){
  if (is.null(getOption("golem.wd"))){
    cat_red_bullet("Couldn't find golem working directory")
    cat_green_tick("Definining golem working directory as `.`")
    cat_line("You can change golem working directory with set_golem_wd('path/to/wd')")
    set_golem_wd(".")
  }
  getOption("golem.wd")
}

#' @export
#' @rdname golem_wd
set_golem_wd <- function(
  path, 
  talkative = TRUE
){
  path <- normalizePath(path, winslash = "/")
  if (talkative){
    cat_green_tick(
      sprintf("Definining golem working directory as `%s`", path)
    )
  }
  options("golem.wd" = path)
  invisible(path)
}
