#' {golem} addins
#' 
#' Addins to go to common files used in developing a `{golem}` package.
#' 
#' @param file Name of the file to be loaded from the `dev` directory.
#' @param wd Working directory of the current golem package.

go_to <- function(
  file,
  wd = golem::get_golem_wd()
){
  file <- file.path(
    wd, file
  )
  if (! file.exists(file)){
    message(file, "not found.")
  }
  if (rstudioapi::hasFun("navigateToFile") ){
    rstudioapi::navigateToFile(
      file
    )
  } else {
    message("Your version of RStudio does not support `navigateToFile`")
  }
}

go_to_start <- function(){
  go_to("dev/01_start.R")
}

go_to_dev <- function(){
  go_to("dev/02_dev.R")
}

go_to_deploy <- function(){
  go_to("dev/03_deploy.R")
}

go_to_run_dev <- function(){
  go_to("dev/run_dev.R")
}

go_to_app_ui <- function(){
  go_to("R/app_ui.R")
}

go_to_app_server <- function(){
  go_to("R/app_server.R")
}

go_to_run_app <- function(){
  go_to("R/run_app.R")
}