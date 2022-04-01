# Getting the DESCRIPTION file in a data.frame
daf_desc <- function(
  path = ".",
  entry
) {
  unlist(
    unname(
      as.data.frame(
        read.dcf(
          normalizePath(
            file.path(path, "DESCRIPTION")
          )
        )
      )[entry]
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
pkg_path <- function(
  path = ".",
  depth = 3
) {
  # We use depth 3 bcs it's the deepest you can be
  # i.e. inst/app/www/
  path <- normalizePath(path)
  if (file.exists(file.path(path, "DESCRIPTION"))) {
    return(path)
  }
  for (i in 1:depth) {
    path <- dirname(path)
    if (
      file.exists(
        file.path(
          path,
          "DESCRIPTION"
        )
      )
    ) {
      return(path)
    }
  }
  stop("Unable to locate the package path.")
}
