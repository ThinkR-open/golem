#' Create a module
#' 
#' These functions create files inside the `inst/app/www` folder. 
#' 
#' @inheritParams  add_module
#' @param dir Path to the dir of the file
#' @export
#' @rdname add_files
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit

add_js_file <- function(
  name, 
  pkg = ".", 
  dir = "inst/app/www"
){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  if ( !check_dir_exist(dir) ) {
    return(invisible(FALSE))
  }  else {
    dir.create(dir, recursive = TRUE)
  }
  
  where <- file.path(
    pkg, dir, glue::glue("{name}.js")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  file.create(where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}

#' @export
#' @rdname add_files

add_js_handler <- function(
  name, 
  pkg = ".", 
  dir = "inst/app/www"
){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  if ( !check_dir_exist(dir) ) {
    return(invisible(FALSE))
  }  else {
    dir.create(dir, recursive = TRUE)
  }
  
  where <- file.path(
    pkg, dir, glue::glue("{name}.js")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  file.create(where)
  
  write_there <- function(...){
    write(..., file = where, append = TRUE)
  }
  glue <- function(...){
    glue::glue(..., .open = "%", .close = "%")
  }
  write_there("$( document ).ready(function() {")
  write_there("  Shiny.addCustomMessageHandler('fun', function(arg) {")
  write_there("  ")
  write_there("  }")
  write_there("});")
  
  cat_green_tick(glue::glue("File created at {where}"))
  
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}

#' @export
#' @rdname add_files
add_css_file <- function(
  name, 
  pkg = ".", 
  dir = "inst/app/www"
){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  if ( !check_dir_exist(dir) ) {
    return(invisible(FALSE))
  }  else {
    dir.create(dir, recursive = TRUE)
  }
  
  where <- file.path(
    pkg, dir, glue::glue("{name}.css")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  file.create(where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}