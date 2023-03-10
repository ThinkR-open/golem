# Getting the DESCRIPTION file in a data.frame
daf_desc <- function(
    path = ".",
    entry) {
  as.character(
    unlist(
      unname(
        as.data.frame(
          read.dcf(
            normalizePath(
              fs_path(path, "DESCRIPTION")
            )
          )
        )[entry]
      )
    )
  )
}

#' Package tools
#'
#' These are functions to help you navigate
#' inside your project while developing
#'
#' @param path Path to use to read the DESCRIPTION
#'
#' @export
#' @rdname pkg_tools
#'
#' @return The value of the entry in the DESCRIPTION file
pkg_name <- function(path = ".") {
  daf_desc(path, "Package")
}
#' @export
#' @rdname pkg_tools
pkg_version <- function(path = ".") {
  daf_desc(path, "Version")
}
#' @export
#' @rdname pkg_tools
pkg_path <- function() {
  # rlang::check_installed("here")
  # here::here()
  getwd()
}
