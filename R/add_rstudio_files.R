#' @importFrom utils capture.output
add_rstudio_files <- function(
  pkg,
  open,
  service = c(
    "RStudio Connect",
    "Shiny Server",
    "ShinyApps.io"
  )
) {
  service <- match.arg(service)
  where <- fs_path(pkg, "app.R")

  rlang::check_installed(
    "pkgload",
    reason = "to deploy on RStudio products."
  )

  disable_autoload(
    pkg = pkg
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- write_there_builder(where)

    usethis_use_build_ignore(basename(where))
    usethis_use_build_ignore("rsconnect")
    write_there("# Launch the ShinyApp (Do not remove this comment)")
    write_there("# To deploy, run: rsconnect::deployApp()")
    write_there("# Or use the blue button on top of this file")
    write_there("")
    write_there("pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)")
    write_there("options( \"golem.app.prod\" = TRUE)")
    write_there(
      sprintf(
        "%s::run_app() # add parameters here (if any)",
        get_golem_name()
      )
    )

    # We add {pkgload} as a dep because it's required to deploy on Connect & stuff
    usethis_use_package("pkgload")

    cat_created(where)
    cli_cat_line("To deploy, run:")
    cli_cat_bullet(crayon_darkgrey("rsconnect::deployApp()\n"))
    cat_red_bullet(
      sprintf(
        "Note that you'll need to upload the whole package to %s",
        service
      )
    )

    add_rscignore_file(pkg = pkg, open = open)

    open_or_go_to(where, open)
  } else {
    cat_green_tick("The 'app.R'-file already exists.")
    open_or_go_to(
      where = where,
      open_file = open
    )
  }
}

#' Add an `app.R` at the root of your package to deploy on RStudio Connect
#'
#' Additionally, adds a `.rscignore` at the root of the `{golem}` project if the
#' `rsconnect` package version is `>= 0.8.25`.
#'
#' @note
#' In previous versions, this function was called add_rconnect_file.
#'
#' @section List of excluded files in `.rscignore`:
#'    * .here
#'    * CODE_OF_CONDUCT.md
#'    * LICENSE\{.md\}
#'    * LICENCE\{.md\}
#'    * NEWS\{.md\}
#'    * README\{.md,.Rmd,.HTML\}
#'    * dev
#'    * man
#'    * tests
#'    * vignettes
#'
#'
#' @inheritParams add_module
#' @aliases add_rconnect_file add_rstudioconnect_file add_positconnect_file
#' @export
#'
#' @rdname rstudio_deploy
#'
#' @return Side-effect functions for file creation returning the path to the
#'    file, invisibly.
#'
#' @examples
#' # Add a file for Connect
#' if (interactive()) {
#'   add_positconnect_file()
#' }
#' # Add a file for Shiny Server
#' if (interactive()) {
#'   add_shinyserver_file()
#' }
#' # Add a file for Shinyapps.io
#' if (interactive()) {
#'   add_shinyappsio_file()
#' }
add_positconnect_file <- function(
  pkg = get_golem_wd(),
  open = TRUE
) {
  add_rstudio_files(
    pkg = pkg,
    open = open,
    service = "RStudio Connect"
  )
}

#' @rdname rstudio_deploy
#' @note `add_rstudioconnect_file` is now deprecated; replace by [add_positconnect_file()].
#' @export
add_rstudioconnect_file <- function(
  pkg = get_golem_wd(),
  open = TRUE
) {
  .Deprecated("add_positconnect_file")
  add_positconnect_file(
    pkg = get_golem_wd(),
    open = TRUE
  )
}

#' @rdname rstudio_deploy
#' @export
add_shinyappsio_file <- function(
  pkg = get_golem_wd(),
  open = TRUE
) {
  add_rstudio_files(
    pkg = pkg,
    open = open,
    service = "ShinyApps.io"
  )
}

#' @rdname rstudio_deploy
#' @export
add_shinyserver_file <- function(
  pkg = get_golem_wd(),
  open = TRUE
) {
  add_rstudio_files(
    pkg = pkg,
    open = open,
    service = "Shiny Server"
  )
}
#' @inheritParams add_module
#' @rdname rstudio_deploy
#' @export
add_rscignore_file <- function(pkg = get_golem_wd(), open = TRUE) {
  min_rsc <- "0.8.25"
  check_min_rsc <- rlang::is_installed("rsconnect", version = min_rsc)
  if (isFALSE(check_min_rsc)) {
    cat_red_bullet(
      sprintf(
        "Not creating '.rscignore'. Required 'rsconnect' version >= %s!",
        min_rsc
      )
    )
    return(invisible(pkg))
  }

  where <- fs_path(pkg, ".rscignore")
  if (isTRUE(fs_file_exists(where))) {
    cat_green_tick("The '.rscignore'-file already exists.")
    open_or_go_to(
      where = where,
      open_file = open
    )
    return(invisible(pkg))
  }
  list_exclusion_defaults <- c(
    ".here",
    "CODE_OF_CONDUCT.md",
    "LICENSE",
    "LICENCE",
    "LICENSE.md",
    "LICENCE.md",
    "NEWS",
    "NEWS.md",
    "README.md",
    "README.Rmd",
    "README.HTML",
    "dev",
    "man",
    "vignettes",
    "tests"
  )
  writeLines(text = list_exclusion_defaults, con = where)
  usethis_use_build_ignore(".rscignore")

  cat_created(where)
  return(invisible(pkg))
}
