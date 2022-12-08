#' Disabling Shiny Autoload of R Scripts
#'
#' @inheritParams add_module
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   disable_autoload()
#' }
#' @return The path to the file, invisibly.
disable_autoload <- function(pkg = get_golem_wd()) {
  fls <- fs::path(
    pkg,
    "R",
    "_disable_autoload.R"
  )
  if (fs::file_exists(fls)) {
    cat_red_bullet(
      "_disable_autoload.R already exists, skipping its creation."
    )
  } else {
    cli::cat_rule("Creating _disable_autoload.R")
    write(
      "# Disabling shiny autoload\n\n# See ?shiny::loadSupport for more information",
      fls
    )
    cat_green_tick("Created")
  }
  return(
    invisible(
      fls
    )
  )
}
