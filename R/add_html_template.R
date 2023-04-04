#' @export
#' @rdname add_files
add_html_template <- function(
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE
    ) {
  name <- file_path_sans_ext(name)

  check_name_length(name)

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
      "%s.html",
      name
    )
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    write_there <- function(...) write(..., file = where, append = TRUE)
    write_there("<!DOCTYPE html>")
    write_there("<html>")
    write_there("  <head>")
    write_there(
      sprintf(
        "    <title>%s</title>",
        get_golem_name()
      )
    )
    write_there("  </head>")
    write_there("  <body>")
    write_there("    {{ body }}")
    write_there("  </body>")
    write_there("</html>")
    write_there("")
    file_created_dance(
      where,
      after_creation_message_html_template,
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
add_partial_html_template <- function(
  name = "partial_template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE
    ) {
  name <- file_path_sans_ext(name)
  check_name_length(name)

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
      "%s.html",
      name
    )
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    write_there <- function(...) write(..., file = where, append = TRUE)
    write_there("<div>")
    write_there("  {{ content }}")
    write_there("</div>")
    write_there("")
    file_created_dance(
      where,
      after_creation_message_html_template,
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