#' Create Files
#' 
#' These functions create files inside the `inst/app` folder. 
#' These functions can be used outside of a {golem} project. 
#' 
#' @inheritParams  add_module
#' @param dir Path to the dir where the file while be created.
#' @param with_doc_ready Should the default file include `$( document ).ready()`?
#' @export
#' @rdname add_files
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit
#' @importFrom fs path_abs path file_create file_exists
add_js_file <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE, 
  with_doc_ready = TRUE
){
  attempt::stop_if(
    rlang::is_missing(name),
    msg = "Name is required"
  )
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg))  
  on.exit(setwd(old))
  
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
    dir, sprintf("%s.js", name)
  )
  
  file_create(where)
  
  if (with_doc_ready){
    write_there <- function(...){
      write(..., file = where, append = TRUE)
    }
    write_there("$( document ).ready(function() {")
    write_there("  ")
    write_there("});")
  }
  
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
#' @rdname add_files
#' @importFrom fs path_abs path file_create file_exists
add_js_handler <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  attempt::stop_if(
    rlang::is_missing(name),
    msg = "Name is required"
  )
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
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
  
  where <- file.path(
    dir, sprintf("%s.js", name)
  )
  
  file_create(where)
  
  write_there <- function(...){
    write(..., file = where, append = TRUE)
  }
  
  write_there("$( document ).ready(function() {")
  write_there("  Shiny.addCustomMessageHandler('fun', function(arg) {")
  write_there("  ")
  write_there("  })")
  write_there("});")
  
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
#' @rdname add_files
#' @importFrom fs path_abs path file_create file_exists
add_css_file <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  attempt::stop_if(
    rlang::is_missing(name),
    msg = "Name is required"
  )
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg)) 
  on.exit(setwd(old))
  
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
    dir, sprintf(
      "%s.css", 
      name
    )
  )
  
  file_create(where)
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
#' @rdname add_files
#' @importFrom fs path_abs file_create
add_ui_server_files <- function(
  pkg = get_golem_wd(), 
  dir = "inst/app",
  dir_create = TRUE
){
  
  #browser()
  old <- setwd(path_abs(pkg))   
  on.exit(setwd(old))
  
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
  
  # UI
  where <- path( dir, "ui.R")
  
  file_create(where)
  
  write_there <- function(...) write(..., file = where, append = TRUE)
  
  if (is.null(getOption('golem.pkg.name'))){
    pkg <- pkgload::pkg_name()
  } else {
    pkg <- getOption('golem.pkg.name')
  }
  
  write_there(
    sprintf( "%s:::app_ui()", pkg )
  )
  
  cat_created(where, "ui file")
  
  # server
  where <- file.path(
    dir, "server.R"
  )
  
  file_create(where)
  
  write_there <- function(...) write(..., file = where, append = TRUE)
  
  write_there(
    sprintf(
      "%s:::app_server",
      pkg
    )
  )
  cat_created(where, "server file")
  
}
