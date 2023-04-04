#' Create Files
#'
#' These functions create files inside the `inst/app` folder.
#'
#' @inheritParams  add_module
#' @param dir Path to the dir where the file while be created.
#' @param with_doc_ready For JS file - Should the default file include `$( document ).ready()`?
#' @param template Function writing in the created file.
#' You may overwrite this with your own template function.
#' @param ... Arguments to be passed to the `template` function.
#' @param initialize For JS file - Whether to add the initialize method.
#'      Default to FALSE. Some JavaScript API require to initialize components
#'      before using them.
#' @param dev Whether to insert console.log calls in the most important
#'      methods of the binding. This is only to help building the input binding.
#'      Default is FALSE.
#' @param events List of events to generate event listeners in the subscribe method.
#'     For instance, `list(name = c("click", "keyup"), rate_policy = c(FALSE, TRUE))`.
#'     The list contain names and rate policies to apply to each event. If a rate policy is found,
#'     the debounce method with a default delay of 250 ms is applied. You may edit manually according to
#'     <https://shiny.rstudio.com/articles/building-inputs.html>
#' @export
#' @rdname add_files
#' @importFrom attempt stop_if
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit
#'
#' @note `add_ui_server_files` will be deprecated in future version of `{golem}`
#'
#' @seealso \code{\link{js_template}}, \code{\link{js_handler_template}}, and \code{\link{css_template}}
#'
#' @return The path to the file, invisibly.


add_blank_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  template = golem::blank_template,
  ...
) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  extension <- file_ext(name)

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

  if (extension != "") {
    where <- fs_path(
      dir,
      sprintf(
        "%s.%s",
        name,
        extension
      )
    )
  } else {
    where <- fs_path(
      dir,
      sprintf(
        "%s",
        name
      )
    )
  }

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    template(path = where, ...)
    file_created_dance(
      where,
      after_creation_message,
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
add_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  template = golem::blank_template,
  ...
) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  extension <- file_ext(name)

  if (extension == "css") {
    add_css_file(
      name = name,
      pkg = pkg,
      dir = dir,
      open = open,
      dir_create = dir_create,
      template = template,
      ...
    )
  } else if (extension == "js") {
    add_js_file(
      name = name,
      pkg = pkg,
      dir = dir,
      open = open,
      dir_create = dir_create,
      template = template,
      ...
    )
  } else if (extension == "sass") {
    add_sass_file(
      name = name,
      pkg = pkg,
      dir = dir,
      open = open,
      dir_create = dir_create,
      template = template,
      ...
    )
  } else {
    add_blank_file(
      name = name,
      pkg = pkg,
      dir = dir,
      open = open,
      dir_create = dir_create,
      template = template,
      ...
    )
  }
}

#' @export
#' @rdname add_files
add_ui_server_files <- function(
  pkg = get_golem_wd(),
  dir = "inst/app",
  dir_create = TRUE
) {
  .Deprecated(msg = "This function will be deprecated in a future version of {golem}.\nPlease comment on https://github.com/ThinkR-open/golem/issues/445 if you want it to stay.")

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

  # UI
  where <- fs_path(dir, "ui.R")

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- function(...) write(..., file = where, append = TRUE)

    pkg <- get_golem_name()

    write_there(
      sprintf("%s:::app_ui()", pkg)
    )

    cat_created(where, "ui file")
  } else {
    cat_green_tick("UI file already exists.")
  }

  # server
  where <- file.path(
    dir,
    "server.R"
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- function(...) write(..., file = where, append = TRUE)

    write_there(
      sprintf(
        "%s:::app_server",
        pkg
      )
    )
    cat_created(where, "server file")
  } else {
    cat_green_tick("server file already exists.")
  }
}
