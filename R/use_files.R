#' Use Files
#' 
#' These functions download files from external sources and install them inside the appropriate directory. 
#' 
#' @inheritParams  add_module
#' @param url String representation of URL for the file to be downloaded
#' @param dir Path to the dir where the file while be created.
#' @note See `?htmltools::htmlTemplate` and `https://shiny.rstudio.com/articles/templates.html` for more information about `htmlTemplate`.
#' @export
#' @rdname use_files
#' @importFrom cli cat_bullet
#' @importFrom fs path_abs path
use_external_js_file <- function(
  url,
  name,
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = FALSE, 
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
  
  cat_line("")
  cat_rule("Initiating file download")
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
  open = FALSE, 
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
  
  cat_line("")
  cat_rule("Initiating file download")
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

#' @export
#' @rdname use_files
#' @importFrom fs path_abs
use_html_template <- function(
  url,
  name = "template.html",
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = FALSE, 
  dir_create = TRUE
){

  old <- setwd(path_abs(pkg))  
  on.exit(setwd(old))
  
  new_file <- sprintf(
    "%s.html", 
    file_path_sans_ext(name)
  )
  
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
  
  cat_line("")
  cat_rule("Initiating file download")
  
  utils::download.file(url, where)
  
  file_created_dance(
    where, 
    after_creation_message_css, 
    pkg, 
    dir, 
    name,
    open
  )
  
  cat_line("")
  cat_rule("To use this html as a template, add the following code in app_ui.R:")
  cat_line(darkgrey('htmlTemplate('))
  cat_line(darkgrey('    app_sys("app/www/template.html"),'))
  cat_line(darkgrey('    # add here the template arguments'))
  cat_line(darkgrey(')'))
}
