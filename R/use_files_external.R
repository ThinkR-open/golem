# For mocking in test
utils_download_file <- function(...) {
  utils_download_file(...)
}
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
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_directory_exists(dir)

  check_url_has_the_correct_extension(
    url,
    "js"
  )

  name <- build_name(
    name,
    url
  )

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.js", name)
  )

  check_file_exists(where)

  download_external(url, where)

  file_created_dance(
    where,
    after_creation_message_js,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE,
    catfun = cat_downloaded
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
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_directory_exists(dir)

  check_url_has_the_correct_extension(
    url,
    "css"
  )

  name <- build_name(
    name,
    url
  )

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.css", name)
  )

  check_file_exists(where)

  download_external(url, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE,
    catfun = cat_downloaded
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
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_directory_exists(dir)

  check_url_has_the_correct_extension(
    url,
    "html"
  )

  name <- build_name(
    name,
    url
  )

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf(
      "%s.html",
      name
    )
  )

  check_file_exists(where)

  download_external(url, where)

  file_created_dance(
    where,
    after_creation_message_html_template,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE
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
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_directory_exists(dir)

  name <- build_name(
    name,
    url
  )

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    name
  )

  check_file_exists(where)

  download_external(url, where)

  file_created_dance(
    where,
    after_creation_message_any_file,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE
  )
}
