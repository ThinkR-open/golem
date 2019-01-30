#' Create a package for Shiny App
#'
#' @param path Where to create the package
#' @param ... not used
#' @export
create_shiny_template <- function(path, ...) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  devtools::create(path = path)
  from <- system.file("shinyexample",package = "golem")
  ll <- list.files(path = from, full.names = TRUE, all.files = TRUE)
  # remove `..`
  ll <- ll[ ! grepl("\\.\\.$",ll)]
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
  
  t <- list.files(path,all.files = TRUE,recursive = TRUE,include.dirs = FALSE,full.names = TRUE)
  for ( i in t){
    message(i)
    try(replace_word(file =   i,
                 pattern = "shinyexample",
                 replace = basename(path)
    ))
  }
  print("done")
}
