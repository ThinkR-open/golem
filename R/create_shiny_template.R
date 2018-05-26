#' Create a Rstudio Project dedicated to shinyapp
#'
#' @param path path to create
#' @param ... not used
#' @export
#' 
# DESCRIPTION
# inst/app/server.R
# inst/app/UI.R
# run_dev_mod

create_shiny_template <- function(path, ...) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  devtools::create(path = path)
  from <- system.file("shinyexample",package = "shinytemplate")
  ll <- list.files(path = from, full.names = TRUE, all.files = TRUE)
  # remove `..`
  ll <- ll[ ! grepl("\\.\\.$",ll)]
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
  
  t <- list.files(path,all.files = TRUE,recursive = TRUE,include.dirs = FALSE,full.names = TRUE)
  browser() 
  for ( i in t){
    message(i)
    try(replace_word(file =   i,
                 pattern = "shinyexample",
                 replace = basename(path)
    ))
  }
  print("fin")
  # DESCRIPTION
  # inst/app/server.R
  # inst/app/UI.R
  # run_dev_mod
  
  
  }
