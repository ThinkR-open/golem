# Getting the DESCRIPTION file in a data.frame
daf_desc <- function(
  golem_wd = get_golem_wd(),
  entry,
  path
) {
  signal_arg_is_deprecated(
    path,
    fun = as.character(sys.call()[[1]])
  )
  as.character(
    unlist(
      unname(
        as.data.frame(
          read.dcf(
            normalizePath(
              fs_path(golem_wd, "DESCRIPTION")
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
#' @param golem_wd Path to use to read the DESCRIPTION
#' @param path Deprecated, use golem_wd instead
#'
#' @export
#' @rdname pkg_tools
#'
#' @return The value of the entry in the DESCRIPTION file
pkg_name <- function(
  golem_wd = get_golem_wd(),
  path
) {
  signal_arg_is_deprecated(
    path,
    fun = as.character(sys.call()[[1]])
  )
  daf_desc(
    golem_wd,
    "Package"
  )
}
#' @export
#' @rdname pkg_tools
pkg_version <- function(
  golem_wd = get_golem_wd(),
  path
) {
  signal_arg_is_deprecated(
    path,
    fun = as.character(sys.call()[[1]])
  )
  daf_desc(
    golem_wd,
    "Version"
  )
}
#' @export
#' @rdname pkg_tools
pkg_path <- function() {
  # rlang::check_installed("here")
  # here::here()
  getwd()
}
