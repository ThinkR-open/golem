#' Create a package for Shiny App
#'
#' @param path Name of the folder to create the package in. This will also be 
#'     used as the package name.
#' @param check_name When using this function in the console, you can prevent 
#'      the package name from being checked. 
#' @param ... not used
#' @importFrom yesno yesno
#' @importFrom cli cat_rule
#' @importFrom utils getFromNamespace
#' @importFrom stringr str_remove_all

#' @export
create_shiny_template <- function(path, check_name = TRUE,...) {
  #browser()
  
  if (check_name){
    check_package_name <- getFromNamespace("check_package_name", "usethis")
    check_package_name(basename(path))
  }
  
  if (dir.exists(path)){
    res <- yesno::yesno(
      paste("The path", path, "already exists, override?")
    )
    if (!res){
      return(invisible(NULL))
    }
  }
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  
  from <- system.file("shinyexample",package = "golem")
  ll <- list.files(path = from, full.names = TRUE, all.files = TRUE,no.. = TRUE)
  # remove `..`
  
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
  
  t <- list.files(
    path,
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = FALSE,
    full.names = TRUE
  )
  
  
  for ( i in t ){
    file.rename(
      from = i,
      to =str_remove_all(i, "REMOVEME")
    )
    
    try({
      replace_word(
        file =   i,
        pattern = "shinyexample",
        replace = basename(path)
      )
    },
    silent=TRUE)
  }
  cat_rule("Created")
  return( invisible(path) )
}
