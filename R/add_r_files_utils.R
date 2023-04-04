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
