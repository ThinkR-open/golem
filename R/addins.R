#' `{golem}` addins
#'
#' `insert_ns()` takes a selected character vector and wrap it in `ns()`
#'  The series of `go_to_*()` addins help you go to
#'  common files used in developing a `{golem}` application.
#'
#' @param wd The working directory of the `{golem}` application.
#'
#' @importFrom attempt stop_if_not
#'
#' @aliases addins
#' @rdname addins
#' @name addins
NULL

#' @rdname addins
#' @aliases addins
insert_ns <- function() {
  stop_if_not(
    rstudioapi_hasFun("getSourceEditorContext"),
    msg = "Your version of RStudio does not support `getSourceEditorContext`"
  )

  stop_if_not(
    rstudioapi_hasFun("modifyRange"),
    msg = "Your version of RStudio does not support `modifyRange`"
  )

  curr_editor <- rstudioapi_getSourceEditorContext()

  id <- curr_editor$id
  sel_rng <- curr_editor$selection[[1]]$range
  sel_text <- curr_editor$selection[[1]]$text

  mod_text <- paste0("ns(", sel_text, ")")

  rstudioapi_modifyRange(
    sel_rng,
    mod_text,
    id = id
  )
}

go_to <- function(
  file,
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  file <- fs_path(
    wd,
    file
  )
  if (!fs_file_exists(file)) {
    message(file, "not found.")
  }

  stop_if_not(
    rstudioapi_hasFun("navigateToFile"),
    msg = "Your version of RStudio does not support `navigateToFile`"
  )

  rstudioapi_navigateToFile(file)
}

#' @rdname addins
#' @aliases addins
go_to_start <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  go_to(
    "dev/01_start.R",
    wd = wd
  )
}
#' @rdname addins
#' @aliases addins
go_to_dev <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  go_to(
    "dev/02_dev.R",
    wd = wd
  )
}
#' @rdname addins
#' @aliases addins
go_to_deploy <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
}
#' @rdname addins
#' @aliases addins
go_to_run_dev <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
}
#' @rdname addins
#' @aliases addins
go_to_app_ui <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  go_to(
    "R/app_ui.R",
    wd = wd
  )
}
#' @rdname addins
#' @aliases addins
go_to_app_server <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  go_to(
    "R/app_server.R",
    wd = wd
  )
}
#' @rdname addins
#' @aliases addins
go_to_run_app <- function(
  golem_wd = golem::get_golem_wd(),
  wd
) {
  signal_arg_is_deprecated(
    wd,
    fun = as.character(sys.call()[[1]]),
    "wd"
  )
  go_to(
    "R/run_app.R",
    wd = wd
  )
}
