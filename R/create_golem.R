#' Create a package for Shiny App using golem
#'
#' @param path Name of the folder to create the package in. This will also be 
#'     used as the package name.
#' @param check_name When using this function in the console, you can prevent 
#'      the package name from being checked. 
#' @param open Boolean open the created project
#' @param package_name Package name to use.By default it's `basename(path)` but if path == '.' and `package_name` 
#' not explicitly given, then `basename(getwd())` will be used.
#' @param without_comments Boolean start project without golem comments
#' @param project_hook A function executed as a hook after project creation. Can be used to change the default `{golem}` structure.
#' to override the files and content. This function is executed 
#' @param ... Arguments passed to the `project_hook()` function.  
#'
#' @importFrom cli cat_rule cat_line
#' @importFrom utils getFromNamespace
#' @importFrom rstudioapi isAvailable openProject
#' @importFrom usethis use_latest_dependencies
#' @importFrom fs path_abs path_file path dir_copy path_expand
#' @importFrom yaml write_yaml
#' @export
create_golem <- function(
  path, 
  check_name = TRUE,
  open = TRUE,
  package_name = basename(path),
  without_comments = FALSE,
  project_hook = golem::project_hook,
  ...
) {
 
  path <- path_expand(path)
  
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
  
  
  if ( rstudioapi::isAvailable() ) { 
    cat_rule("Rstudio project initialisation")
    rproj_path <- rstudioapi::initializeProject(path = path)
    
    if (file.exists(rproj_path)){
      
    enable_roxygenize(path = rproj_path)
      
    }else{
      stop("can't create .Rproj file ")
      
    }
    
    
    
  }
  

  
  cat_rule("Copying package skeleton")
  from <- golem_sys("shinyexample")

  # Copy over whole directory
  dir_copy(path = from, new_path = path, overwrite = TRUE)
  
  # Listing copied files ***from source directory***
  copied_files <- list.files(path = from,
                             full.names = FALSE,
                             all.files = TRUE,
                             recursive = TRUE)

  # Going through copied files to replace package name
  for (f in copied_files) {
    copied_file <- file.path(path, f)

    if (grepl("^REMOVEME", f)) {
      file.rename(from = copied_file,
                  to = file.path(path, gsub("REMOVEME", "", f)))
      copied_file <- file.path(path, gsub("REMOVEME", "", f))
    }
    
    if (!grepl("ico$", copied_file)) {
      try({
        replace_word(
          file = copied_file,
          pattern = "shinyexample",
          replace = package_name)
      }, silent = TRUE)
    }
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
  write_yaml(conf, yml_path)
  
  cat_green_tick("Configured app")
  cat_rule("Running project hook function")
  old <- setwd(path)
  # TODO fix
  # for some weird reason test() fails here when using golem::
  # and I don't have time to search why rn
  if (substitute(project_hook) == "golem::project_hook"){
    project_hook <- getFromNamespace("project_hook", "golem")
  }
  project_hook(path = path, package_name = package_name, ...)
  setwd(old)
  
  cat_green_tick("All set")
  
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
  
  old <- setwd(path)
  use_latest_dependencies()
  
  cat_rule("Appending .Rprofile")
  write("# Sourcing user .Rprofile if it exists ", ".Rprofile", append = TRUE)
  write("home_profile <- file.path(", ".Rprofile", append = TRUE)
  write("  Sys.getenv(\"HOME\"), ", ".Rprofile", append = TRUE)
  write("  \".Rprofile\"", ".Rprofile", append = TRUE)
  write(")", ".Rprofile", append = TRUE)
  write("if (file.exists(home_profile)){", ".Rprofile", append = TRUE)
  write("  source(home_profile)", ".Rprofile", append = TRUE)
  write("}", ".Rprofile", append = TRUE)
  write("# Setting shiny.autoload.r to FALSE ", ".Rprofile", append = TRUE)
  write("options(shiny.autoload.r = FALSE)", ".Rprofile", append = TRUE)
  cat_green_tick("Appended")
  
  setwd(old)
  
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
  attempt::stop_if_not(
    dots$project_hook, 
    ~ grepl("::", .x), 
    "{golem} project templates must be explicitely namespaced (pkg::fun)"
  )
  splt <- strsplit(dots$project_hook, "::")
  project_hook <- getFromNamespace(
    splt[[1]][2], 
    splt[[1]][1]
  )
  create_golem(
    path = path,
    open = FALSE,
    without_comments = dots$without_comments,
    project_hook = project_hook, 
    check_name = dots$check_name
  )
}

