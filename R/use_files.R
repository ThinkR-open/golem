#' Use Files
#' 
#' These functions download files from external sources and install them inside the appropriate directory. 
#' 
#' @inheritParams  add_module
#' @param url String representation of URL for the file to be downloaded
#' @param dir Path to the dir where the file while be created.
#' @export
#' @rdname use_files
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @importFrom fs path_abs path
use_external_js_file <- function(
  url,
  name,
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  
  old <- setwd(path_abs(pkg))  
  on.exit(setwd(old))
  new_file <- glue::glue("{name}.js")
  
  dir_created <- create_dir_if_needed(
    dir, 
    dir_create
  )
  
  if (!dir_created){
    cat_red_bullet(
      "File not added (needs a valid directory)"
    )
    return(invisible(FALSE))
  }
  
  dir <- path_abs(dir) 
  
  where <- path(
    dir, new_file
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  if ( tools::file_ext(url) != "js") {
    cat_red_bullet(
      "File not added (URL must end with .js extension)"
    )
    return(invisible(FALSE))
  }
  
  utils::download.file(url, where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  cat_red_bullet(
    glue::glue(
      'To link to this file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$script(src="www/{name}.js")`'
    )
  )
  
  if (rstudioapi::isAvailable() & open){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}

#' @export
#' @rdname use_files
#' @importFrom fs path_abs
use_external_css_file <- function(
  url,
  name,
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  
  old <- setwd(path_abs(pkg))  
  on.exit(setwd(old))
  new_file <- glue::glue("{name}.css")
  
  dir_created <- create_dir_if_needed(
    dir, 
    dir_create
  )
  
  if (!dir_created){
    cat_red_bullet(
      "File not added (needs a valid directory)"
    )
    return(invisible(FALSE))
  }
  
  dir <- path_abs(dir) 
  
  where <- path(
    dir, new_file
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  if ( tools::file_ext(url) != "css") {
    cat_red_bullet(
      "File not added (URL must end with .css extension)"
    )
    return(invisible(FALSE))
  }
  
  utils::download.file(url, where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  cat_red_bullet(
    glue::glue(
      'To link to this file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$script(src="www/{name}.css")`'
    )
  )
  
  if (rstudioapi::isAvailable() & open){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}