# Getting the DESCRIPTION file in a data.frame
daf_desc <- function(
    pkg = get_golem_wd(),
    entry) {
  as.character(
    unlist(
      unname(
        as.data.frame(
          read.dcf(
            normalizePath(
              fs_path(pkg, "DESCRIPTION")
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
#' @param pkg Path to use to read the DESCRIPTION
#'
#' @export
#' @rdname pkg_tools
#'
#' @return The value of the entry in the DESCRIPTION file
pkg_name <- function(pkg = get_golem_wd()) {
  daf_desc(pkg, "Package")
}
#' @export
#' @rdname pkg_tools
pkg_version <- function(pkg = get_golem_wd()) {
  daf_desc(pkg, "Version")
}
#' @export
#' @rdname pkg_tools
pkg_path <- function() {
  # rlang::check_installed("here")
  # here::here()
  getwd()
}
