#' Use Files
#' 
#' These functions download files from external sources and install them inside the appropriate directory. 
#' 
#' @inheritParams  add_module
#' @param url String representation of URL for the file to be downloaded
#' @param dir Path to the dir where the file while be created.
#' @export
#' @rdname use_files
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
  name <-  file_path_sans_ext(name)
  new_file <- sprintf( "%s.js", name )
  
  dir_created <- create_if_needed(
    dir, type = "directory"
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
  
  if ( file_ext(url) != "js") {
    cat_red_bullet(
      "File not added (URL must end with .js extension)"
    )
    return(invisible(FALSE))
  }
  
  utils::download.file(url, where)
  
  file_created_dance(
    where, 
    after_creation_message_js, 
    pkg, 
    dir, 
    name,
    open
  )
  
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
  name <-  file_path_sans_ext(name)
  new_file <- sprintf("%s.css", name)

  dir_created <- create_if_needed(
    dir, type = "directory"
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

  if ( file_ext(url) != "css") {
    cat_red_bullet(
      "File not added (URL must end with .css extension)"
    )
    return(invisible(FALSE))
  }
  
  utils::download.file(url, where)
  
  file_created_dance(
    where, 
    after_creation_message_css, 
    pkg, 
    dir, 
    name,
    open
  )

}

