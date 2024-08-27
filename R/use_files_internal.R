#' @export
#' @rdname use_files
use_internal_js_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_file_has_the_correct_extension(
    path,
    "js"
  )

  name <- build_name(
    name,
    path
  )

  new_file <- sprintf("%s.js", name)

  check_directory_exists(dir)

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  check_file_exists(where)

  copy_internal_file(path, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    catfun = cat_copied
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
  dir_create = TRUE
) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_file_has_the_correct_extension(
    path,
    "css"
  )

  name <- build_name(
    name,
    path
  )

  new_file <- sprintf("%s.css", name)

  check_directory_exists(dir)

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  check_file_exists(where)
  copy_internal_file(path, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    catfun = cat_copied
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
  dir_create = TRUE
) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_file_has_the_correct_extension(
    path,
    "html"
  )

  name <- build_name(
    name,
    path
  )

  new_file <- sprintf(
    "%s.html",
    file_path_sans_ext(name)
  )

  check_directory_exists(dir)

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  check_file_exists(where)


  copy_internal_file(path, where)

  file_created_dance(
    where,
    after_creation_message_html_template,
    pkg,
    dir,
    name,
    open
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
  dir_create = TRUE
) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  name <- build_name(
    name,
    path
  )

  check_directory_exists(dir)

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    name
  )
  check_file_exists(where)

  copy_internal_file(path, where)

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
