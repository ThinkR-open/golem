#' Add recommended elements
#'
#' \describe{
#'   \item{use_recommended_deps}{Adds `shiny`, `DT`, `attempt`, `glue`, `golem`, `htmltools` to dependencies}
#'   \item{use_recommended_tests}{Adds a test folder and copy the golem tests}
#' }
#'
#' @inheritParams add_module
#' @inheritParams usethis::use_spell_check
#' @param recommended A vector of recommended packages.
#' @param spellcheck Whether or not to use a spellcheck test.
#'
#' @rdname use_recommended
#'
#' @export
#'
#' @return Used for side-effects.
#'
use_recommended_deps <- function(
  pkg = get_golem_wd(),
  recommended = c("shiny", "DT", "attempt", "glue", "htmltools", "golem")
) {
  .Deprecated(
    old = "use_recommended_deps",
    msg = "use_recommended_deps() is currently soft deprecated and will be removed in future versions of {golem}."
  )

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  for (i in sort(recommended)) {
    try(usethis_use_package(i))
  }

  cat_green_tick("Dependencies added")
}


#' @rdname use_recommended
#' @export
#' @importFrom utils capture.output
#' @importFrom attempt without_warning stop_if
use_recommended_tests <- function(
  pkg = get_golem_wd(),
  spellcheck = TRUE,
  vignettes = TRUE,
  lang = "en-US",
  error = FALSE
) {
  old <- setwd(fs_path_abs(pkg))

  on.exit(setwd(old))

  if (!fs_dir_exists(
    fs_path(fs_path_abs(pkg), "tests")
  )) {
    without_warning(usethis_use_testthat)()
  }
  if (!requireNamespace("processx")) {
    stop("Please install the {processx} package to add the recommended tests.")
  }

  stop_if(
    fs_path(pkg, "tests", "testthat", "test-golem-recommended.R"),
    fs_file_exists,
    "test-golem-recommended.R already exists. \nPlease remove it first if you need to reinsert it."
  )

  fs_file_copy(
    golem_sys(
      "utils",
      "test-golem-recommended.R"
     )
     ,
    fs_path(pkg, "tests", "testthat"),
    overwrite = TRUE
  )

  if (spellcheck) {
    usethis_use_spell_check(
      vignettes = vignettes,
      lang = lang,
      error = error
    )
  }
  cat_green_tick("Tests added")
}
