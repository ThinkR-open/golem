#' Automatically serve golem external resources
#' 
#' This function is a wrapper around `htmltools::htmlDependency` that 
#' automatically bundles the CSS and JavaScript files in `inst/app/www`
#' and which are created by `golem::add_css_file()` , `golem::add_js_file()`
#' and `golem::add_js_handler()`.
#'
#' @param path The path to the folder where the external files are located.
#' @param app_title The title of the app, to be used as an application title.
#' @inheritParams htmltools::htmlDependency
#'
#' @export
bundle_resources <- function(
  path, 
  app_title,
  name = "golem_resources", 
  version = "0.0.1", 
  meta = NULL, 
  head = NULL,
  attachment = NULL,
  package = NULL,
  all_files = TRUE
){
  
  htmltools::htmlDependency(
    name, 
    version,
    src = path,
    script = list.files(
      path, 
      pattern = "\\.js$"
    ),
    stylesheet = list.files(
      path, 
      pattern = "\\.css$"
    ),
    meta = meta, 
    head = c(
      as.character(
        tags$title(app_title)
      ), 
      as.character(
        golem::activate_js()
      ),
      head
    ),
    attachment = attachment,
    package = package,
    all_files = all_files
  )
}