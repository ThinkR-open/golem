#' Create a module
#' 
#' These functions create files inside the `inst/app/www` folder. 
#' 
#' @inheritParams  add_module
#' 
#' @export
#' @rdname add_files
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit

add_js_file <- function(name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  where <- file.path(
    pkg, "inst", "app", "www", glue::glue("{name}.js")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  file.create(where)
  
  cat_bullet(
    glue("File created at {where}"), 
    bullet = "tick", 
    bullet_col = "green"
  )
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue("Go to {where}"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
}

#' @export
#' @rdname add_files

add_js_handler <- function(name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  where <- file.path(
    pkg, "inst", "app", "www", glue::glue("{name}.js")
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
  
  cat_bullet(
    glue("File created at {where}"), 
    bullet = "tick",
    bullet_col = "green"
  )
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue("Go to {where}"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
}

#' @export
#' @rdname add_files
add_css_file <- function(name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  where <- file.path(
    pkg, "inst", "app", "www", glue::glue("{name}.css")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  file.create(where)
  
  cat_bullet(
    glue("File created at {where}"), 
    bullet = "tick", 
    bullet_col = "green"
  )
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue("Go to {where}"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
}