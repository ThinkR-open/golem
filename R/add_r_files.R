#' @importFrom fs path_abs path file_create
add_r_files <- function(
  name,
  ext = c("fct", "utils"),
  module = "",
  pkg = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE
) {
  name <- file_path_sans_ext(name)

  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    "R",
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  if (!is.null(module)) {
    # Remove the extension if any
    module <- file_path_sans_ext(module)
    # Remove the "mod_" if any
    module <- mod_remove(module)
    if (!is_existing_module(module)) {
      stop(
        sprintf(
          "The module '%s' does not exist.\nYou can call `golem::add_module('%s')` to create it.",
          module,
          module
        ),
        call. = FALSE
      )
    }
    module <- paste0("mod_", module, "_")
  }

  where <- path(
    "R",
    paste0(module, ext, "_", name, ".R")
  )

  if (!file_exists(where)) {
    file_create(where)

    if (file_exists(where) & is.null(module)) {
      # Must be a function or utility file being created
      append_roxygen_comment(
        name = name,
        path = where,
        ext = ext
      )
    }

    cat_created(where)
  } else {
    file_already_there_dance(
      where = where,
      open_file = open
    )
  }

  if (with_test) {
    usethis::use_test(
      basename(
        file_path_sans_ext(
          where
        )
      )
    )
  }

  open_or_go_to(where, open)
}

#' Add fct_ and utils_ files
#'
#' These functions add files in the R/ folder
#' that starts either with `fct_` (short for function)
#' or with `utils_`.
#'
#' @param name The name of the file
#' @param module If not NULL, the file will be module specific
#'     in the naming (you don't need to add the leading `mod_`).
#' @inheritParams  add_module
#'
#' @rdname file_creation
#' @export
#'
#' @return The path to the file, invisibly.
add_fct <- function(
  name,
  module = NULL,
  pkg = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE
) {
  add_r_files(
    name,
    module,
    ext = "fct",
    pkg = pkg,
    open = open,
    dir_create = dir_create,
    with_test = with_test
  )
}

#' @rdname file_creation
#' @export
add_utils <- function(
  name,
  module = NULL,
  pkg = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE
) {
  add_r_files(
    name,
    module,
    ext = "utils",
    pkg = pkg,
    open = open,
    dir_create = dir_create,
    with_test = with_test
  )
}

#' Append roxygen comments to `fct_` and `utils_` files
#'
#' This function add boilerplate roxygen comments
#' for fct_ and utils_ files.
#'
#' @param name The name of the file
#' @param path The path to the R script where the module will be written.
#' @param ext A string denoting the type of file to be created.
#'
#' @rdname file_creation
#' @noRd
append_roxygen_comment <- function(
  name,
  path,
  ext,
  export = FALSE
) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  file_type <- " "

  if (ext == "utils") {
    file_type <- "utility"
  } else {
    file_type <- "function"
  }

  write_there(sprintf("#' %s ", name))
  write_there("#'")
  write_there(sprintf("#' @description A %s function", ext))
  write_there("#'")
  write_there(sprintf("#' @return The return value, if any, from executing the %s.", file_type))
  write_there("#'")
  if (export) {
    write_there("#' @export")
  } else {
    write_there("#' @noRd")
  }
}
