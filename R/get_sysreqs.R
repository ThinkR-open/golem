# Now in {dockerfiler}

#' Get system requirements (Deprecated)
#'
#' This function retrieves information about the
#' system requirements using the <https://sysreqs.r-hub.io>
#' API. This function is now deprecated, and was moved to
#' {dockerfiler}.
#'
#' @param packages character vector. Packages names.
#' @param batch_n numeric. Number of simultaneous packages to ask.
#' @param quiet Boolean. If `TRUE` the function is quiet.
#'
#'
#' @export
#'
#' @return A vector of system requirements.
get_sysreqs <- function(
  packages,
  quiet = TRUE,
  batch_n = 30
) {
  .Deprecated(
    "dockerfiler::get_sysreqs",
    msg = "get_sysreqs() is deprecated and has been moved to {dockerfiler}."
  )
}
