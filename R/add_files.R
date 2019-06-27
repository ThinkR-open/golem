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
  dir = "inst/app/www",
  open = TRUE
){
  pkg <- normalizePath(pkg)
  old <- setwd(pkg) 
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  check_dir_exist(dir)
  
  where <- file.path(
    dir, 
    glue::glue("{name}.js")
  )
  
  if (file.exists(where) ){
    res <- yesno::yesno("This file already exists, override?")
    if (!res) return(FALSE)
  }
  
  file.create(where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  
  if (rstudioapi::isAvailable() & open){
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
  dir = "inst/app/www",
  open = TRUE
){
  pkg <- normalizePath(pkg)
  old <- setwd(pkg) 
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  check_dir_exist(dir)
  
  where <- file.path(
    dir, 
    glue::glue("{name}.js")
  )
  
  if (file.exists(where) ){
    res <- yesno::yesno("This file already exists, override?")
    if (!res) return(FALSE)
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
  
  if (rstudioapi::isAvailable() & open){
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
  dir = "inst/app/www",
  open = TRUE
){
  pkg <- normalizePath(pkg)
  old <- setwd(pkg) 
  on.exit(setwd(old))
  
  dir <- file.path(pkg, dir)
  
  check_dir_exist(dir)
  
  where <- file.path(
    dir, 
    glue::glue("{name}.css")
  )
  
  if (file.exists(where) ){
    res <- yesno::yesno("This file already exists, override?")
    if (!res) return(FALSE)
  }
  
  file.create(where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  
  if (rstudioapi::isAvailable() & open ){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}