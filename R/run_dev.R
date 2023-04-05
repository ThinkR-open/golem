#' Run run_dev.R
#'
#' @param file File path to `run_dev.R`. Defaults to `R/run_dev.R`.
#' @param save_all boolean. If TRUE, save all open file before sourcing `file`
#' @inheritParams add_module
#'
#' @export
#'
#' @return Used for side-effect
run_dev <- function(
  file = "dev/run_dev.R",
  pkg = get_golem_wd(),
  save_all = TRUE
) {
  if (save_all) {
    if (
      rlang::is_installed("rstudioapi") &&
        rstudioapi::isAvailable() &&
        rstudioapi::hasFun("documentSaveAll")
    ) {
      rstudioapi::documentSaveAll()
    }
  }


  # We'll look for the run_dev script in the current dir
  try_dev <- file.path(
    pkg,
    file
  )

  # Stop if it doesn't exists
  if (file.exists(try_dev)) {
    run_dev_lines <- readLines(
      "dev/run_dev.R"
    )
  } else {
    stop(
      "Unable to locate dev file"
    )
  }

  check_sass_used <- isTRUE(any(grepl("sass::", run_dev_lines)))
  if (check_sass_used) install_single_dev_dep("sass")

  eval(
    parse(
      text = run_dev_lines
    )
  )
}
