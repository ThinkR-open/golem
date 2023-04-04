#' @export
#' @rdname add_files
add_css_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  template = golem::css_template,
  ...
    ) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  name <- file_path_sans_ext(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf(
      "%s.css",
      name
    )
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    template(path = where, ...)
    file_created_dance(
      where,
      after_creation_message_css,
      pkg,
      dir,
      name,
      open
    )
  } else {
    file_already_there_dance(
      where = where,
      open_file = open
    )
  }
}

#' @export
#' @rdname add_files
#' @importFrom cli cli_alert_info
add_sass_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  template = golem::sass_template,
  ...
    ) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  name <- file_path_sans_ext(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir_abs <- fs_path_abs(dir)

  where <- fs_path(
    dir_abs,
    sprintf(
      "%s.sass",
      name
    )
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    template(path = where, ...)
    file_created_dance(
      where,
      after_creation_message_sass,
      pkg,
      dir_abs,
      name,
      open
    )

    add_sass_code(
      where = where,
      dir = dir,
      name = name
    )

    cli_alert_info(
      "After running the compilation, your CSS file will be automatically link in `golem_add_external_resources()`."
    )
  } else {
    file_already_there_dance(
      where = where,
      open_file = open
    )
  }
}