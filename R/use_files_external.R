#' Use Files
#'
#' These functions download files from external sources and put them inside the `inst/app/www` directory.
#' The `use_internal_` functions will copy internal files, while `use_external_` will try to download them
#' from a remote location.
#'
#' @inheritParams add_module
#' @param url String representation of URL for the file to be downloaded
#' @param path String representation of the local path for the file to be implemented (use_file only)
#' @param dir Path to the dir where the file while be created.
#'
#' @note See `?htmltools::htmlTemplate` and `https://shiny.rstudio.com/articles/templates.html`
#'     for more information about `htmlTemplate`.
#'
#' @export
#' @rdname use_files
#'
#' @return The path to the file, invisibly.
use_external_js_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
) {

  perform_checks_and_download_if_everything_is_ok(
    url_to_download_from = url,
    directory_to_download_to = fs_path_abs(dir),
    file_type = "js",
    file_created_fun = after_creation_message_js,
    pkg = pkg,
    name = name,
    open = open
  )

}

#' @export
#' @rdname use_files
use_external_css_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
) {

  perform_checks_and_download_if_everything_is_ok(
    url_to_download_from = url,
    directory_to_download_to = fs_path_abs(dir),
    file_type = "css",
    file_created_fun = after_creation_message_css,
    pkg = pkg,
    name = name,
    open = open
  )
}

#' @export
#' @rdname use_files
use_external_html_template <- function(
  url,
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
) {

  perform_checks_and_download_if_everything_is_ok(
    url_to_download_from = url,
    directory_to_download_to = fs_path_abs(dir),
    file_type = "html",
    file_created_fun = after_creation_message_html_template,
    pkg = pkg,
    name = name,
    open = open
  )
}

#' @export
#' @rdname use_files
use_external_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
) {

  perform_checks_and_download_if_everything_is_ok(
    url_to_download_from = url,
    directory_to_download_to = fs_path_abs(dir),
    file_type = NULL,
    file_created_fun = after_creation_message_any_file,
    pkg = pkg,
    name = name,
    open = open
  )
}
