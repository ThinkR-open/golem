#' Create a package for Shiny App
#'
#' @param path Name of the folder to create the package in. This will also be 
#'     used as the package name.
#' @importFrom yesno yesno
#' @importFrom cli cat_rule
#' @importFrom utils getFromNamespace
#' @importFrom stringr str_remove_all
#' @param ... not used
#' @export
create_shiny_template <- function(path, ...) {
  #browser()
  check_package_name <- getFromNamespace("check_package_name", "usethis")
  check_package_name(basename(path))
  
  if (dir.exists(path)){
    res <- yesno::yesno(
      paste("The path", path, "already exists, override?")
    )
    if (!res){
      return(invisible(NULL))
    }
  }
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  #create_package(path = path)
  from <- system.file("shinyexample",package = "golem")
  ll <- list.files(path = from, full.names = TRUE, all.files = TRUE,no.. = TRUE)
  # remove `..`
  # ll <- ll[ ! grepl("\\.\\.$",ll)]
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
  
  t <- list.files(path,all.files = TRUE,recursive = TRUE,include.dirs = FALSE,full.names = TRUE)

  
  
  
 for ( i in t){
   file.rename(from = i,
   to = i %>% str_remove_all("REMOVEME"))
   
    try(replace_word(file =   i,
                 pattern = "shinyexample",
                 replace = basename(path)
    ),silent=TRUE)
  }
  cat_rule("Created")
  return(invisible(path))
}
