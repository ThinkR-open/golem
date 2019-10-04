#' Create a package for Shiny App using golem
#'
#' @param path Name of the folder to create the package in. This will also be 
#'     used as the package name.
#' @param check_name When using this function in the console, you can prevent 
#'      the package name from being checked. 
#' @param open boolean open the created project
#' @param package_name package name to use
#' @param ... not used
#'
#' @importFrom yesno yesno
#' @importFrom cli cat_rule
#' @importFrom utils getFromNamespace
#' @importFrom stringr str_remove_all
#' @importFrom rstudioapi isAvailable
#' @importFrom rstudioapi openProject
#' @export
create_golem <- function(
  path, 
  check_name = TRUE,
  open =TRUE,
  package_name = basename(path),
  ...
) {
  
  if (check_name){
    getFromNamespace("check_package_name", "usethis")(package_name)
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
  
  from <- golem_sys("shinyexample")
  ll <- list.files(path = from, full.names = TRUE, all.files = TRUE,no.. = TRUE)
  # remove `..`
  file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
  
  t1 <- list.files(
    path,
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = FALSE,
    full.names = TRUE
  )
  t <- grep(
    x = t1, 
    pattern = "ico$",
    invert = TRUE,
    value = TRUE
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
        replace = package_name
      )
    },
    silent=TRUE)
  }
  cat_rule("Created")
  
  
  if ( open & rstudioapi::isAvailable() ) { 
    rstudioapi::openProject(path = path)
  }
  
  
  return( 
    invisible(
      normalizePath(path)
    ) 
  )
}

# to be used in RStudio "new project" GUI
create_golem_gui <- function(path,...){
  create_golem(path=path,open=FALSE)
}