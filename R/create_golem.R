#' Create a package for Shiny App using golem
#'
#' @param path Name of the folder to create the package in. This will also be 
#'     used as the package name.
#' @param check_name When using this function in the console, you can prevent 
#'      the package name from being checked. 
#' @param open Boolean open the created project
#' @param package_name Package name to use.By default it's `basename(path)` but if path == '.' and `package_name` 
#' not explicitly given, then `basename(getwd())` will be used.
#' @param without_comments Poolean start project without golem comments
#' @param ... not used
#'
#' @importFrom cli cat_rule cat_line
#' @importFrom utils getFromNamespace
#' @importFrom rstudioapi isAvailable openProject
#' @importFrom fs path_abs path_file path file_move
#' @export
create_golem <- function(
  path, 
  check_name = TRUE,
  open =TRUE,
  package_name = basename(path),
  without_comments = FALSE,
  ...
) {
  
  if (path == '.' & package_name == path_file(path)){
    package_name <- path_file(getwd())
  }
  
  if (check_name){
    cat_rule("Checking package name")
    getFromNamespace("check_package_name", "usethis")(package_name)
    cat_green_tick("Valid package name")
  }
  
  if (dir_exists(path)){
    res <- yesno(
      paste("The path", path, "already exists, override?")
    )
    if (!res){
      return(invisible(NULL))
    }
  }
  
  cat_rule("Creating dir")
  dir_create(
    path, 
    recurse = TRUE
  )
  cat_green_tick("Created package directory")
  
  cat_rule("Copying package skeleton")
  from <- golem_sys("shinyexample")
  ll <- list.files(
    path = from, 
    full.names = TRUE, 
    all.files = TRUE,
    no.. = TRUE
  )
  # remove `..`
  file.copy(
    ll, 
    path, 
    overwrite = TRUE, 
    recursive = TRUE
  )
  
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
    file_move(
      path = i,
      new_path = gsub("REMOVEME", "", i)
    )
    
    try({
      replace_word(
        file =   i,
        pattern = "shinyexample",
        replace = package_name
      )
    },
    silent = TRUE
    )
  }
  cat_green_tick("Copied app skeleton")
  
  cat_rule("Setting the default config")
  yml_path <- path(path, "inst/golem-config.yml")
  
  conf <- yaml::read_yaml(yml_path, eval.expr = TRUE)
  
  yaml_golem_wd <- "here::here()"
  attr(yaml_golem_wd, "tag") <- "!expr"
  conf$dev$golem_wd <- yaml_golem_wd
  conf$default$golem_name <- package_name
  conf$default$golem_version <- "0.0.0.9000"
  yaml::write_yaml(conf, yml_path)
  
  cat_green_tick("Configured app")
  
  if ( without_comments == TRUE ) {
    files <- list.files(
      path = c(
        path(path, "dev"),
        path(path, "R")
      ), 
      full.names = TRUE
    )
    for ( file in files ) {
      remove_comments(file)
    }
  }
  
  cat_rule("Done")
  
  cat_line(
    paste0(
      "A new golem named ", 
      package_name, 
      " was created at ", 
      path_abs(path),
      " .\n", 
      "To continue working on your app, start editing the 01_start.R file."
    )
  )
  
  if ( open & rstudioapi::isAvailable() ) { 
    rstudioapi::openProject(path = path)
  }
  
  return( 
    invisible(
      path_abs(path)
    ) 
  )
}

# to be used in RStudio "new project" GUI
create_golem_gui <- function(path,...){
  dots <- list(...)
  create_golem(
    path = path,
    open = FALSE,
    without_comments = dots$without_comments
  )
}

