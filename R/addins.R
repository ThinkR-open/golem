#' `{golem}` addins
#' 
#' `insert_ns()` takes a selected character vector and wrap it in `ns()`
#'  The series of `go_to_*()` addins help you go to 
#'  common files used in developing a `{golem}` application.
#'
#' @importFrom rstudioapi getSourceEditorContext modifyRange
#' @importFrom attempt stop_if_not 
#' @importFrom rstudioapi modifyRange
#' 
#' @aliases addins
#' @rdname addins
#' @name addins
NULL

#' @rdname addins
#' @aliases addins
insert_ns <- function() {

  stop_if_not(
    rstudioapi::hasFun("getSourceEditorContext"),
    msg = "Your version of RStudio does not support `getSourceEditorContext`"
  )

  curr_editor <- rstudioapi::getSourceEditorContext()

  id <- curr_editor$id
  sel_rng <- curr_editor$selection[[1]]$range
  sel_text <- curr_editor$selection[[1]]$text

  mod_text <- paste0("ns(", sel_text, ")")

  stop_if_not(
    rstudioapi::hasFun("modifyRange"),
    msg = "Your version of RStudio does not support `modifyRange`"
  )

  rstudioapi::modifyRange(sel_rng, mod_text, id = id)
}

#' @importFrom fs path file_exists
go_to <- function(
  file,
  wd = golem::get_golem_wd()
){
  file <- path(
    wd, file
  )
  if (! file_exists(file)){
    message(file, "not found.")
  }
  
  stop_if_not(
    rstudioapi::hasFun("navigateToFile"), 
    msg = "Your version of RStudio does not support `navigateToFile`"
  )
  
  rstudioapi::navigateToFile( file )
}

#' @rdname addins
#' @aliases addins
go_to_start <- function(){
  go_to("dev/01_start.R")
}
#' @rdname addins
#' @aliases addins
go_to_dev <- function(){
  go_to("dev/02_dev.R")
}
#' @rdname addins
#' @aliases addins
go_to_deploy <- function(){
  go_to("dev/03_deploy.R")
}
#' @rdname addins
#' @aliases addins
go_to_run_dev <- function(){
  go_to("dev/run_dev.R")
}
#' @rdname addins
#' @aliases addins
go_to_app_ui <- function(){
  go_to("R/app_ui.R")
}
#' @rdname addins
#' @aliases addins
go_to_app_server <- function(){
  go_to("R/app_server.R")
}
#' @rdname addins
#' @aliases addins
go_to_run_app <- function(){
  go_to("R/run_app.R")
}

