#' @export
#' @rdname use_files
use_internal_js_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_abort_dir_create()
  }

  perform_checks_and_copy_if_everything_is_ok(
    path_to_copy_from = path,
    directory_to_copy_to = fs_path_abs(dir),
    file_type = "js",
    file_created_fun = after_creation_message_js,
    pkg = pkg,
    name = name,
    open = open
  )
}

#' @export
#' @rdname use_files
use_internal_css_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_abort_dir_create()
  }

  perform_checks_and_copy_if_everything_is_ok(
    path_to_copy_from = path,
    directory_to_copy_to = fs_path_abs(dir),
    file_type = "css",
    file_created_fun = after_creation_message_css,
    pkg = pkg,
    name = name,
    open = open
  )
}

#' @export
#' @rdname use_files
use_internal_html_template <- function(
  path,
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_abort_dir_create()
  }

  perform_checks_and_copy_if_everything_is_ok(
    path_to_copy_from = path,
    directory_to_copy_to = fs_path_abs(dir),
    file_type = "html",
    file_created_fun = after_creation_message_html_template,
    pkg = pkg,
    name = name,
    open = open
  )
}

#' @export
#' @rdname use_files
use_internal_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_abort_dir_create()
  }

  perform_checks_and_copy_if_everything_is_ok(
    path_to_copy_from = path,
    directory_to_copy_to = fs_path_abs(dir),
    file_type = NULL,
    file_created_fun = after_creation_message_html_template,
    pkg = pkg,
    name = name,
    open = open
  )
}
