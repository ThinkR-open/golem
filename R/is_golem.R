#' Is the directory a golem-based app?
#'
#' Trying to guess if `path` is a golem-based app.
#'
#' @param path Path to the directory to check.
#' Defaults to the current working directory.
#'
#' @export
#'
#' @example
#' is_golem()
is_golem <- function(path = getwd()) {
  files_from_shiny_example <- grep(
    "^(?!REMOVEME).*",
    list.files(
      system.file("shinyexample", package = "golem"),
      recursive = TRUE
    ),
    perl = TRUE,
    value = TRUE
  )
  files_from_shiny_example <- grep(
    "favicon.ico",
    files_from_shiny_example,
    perl = TRUE,
    value = TRUE,
    invert = TRUE
  )

  all(
    files_from_shiny_example %in% list.files(path, recursive = TRUE)
  )
}
