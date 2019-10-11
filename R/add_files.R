#' Create Files
#' 
#' These functions create files inside the `inst/app` folder. 
#' These functions can be used outside of a {golem} project. 
#' 
#' @inheritParams  add_module
#' @param dir Path to the dir where the file while be created.
#' @export
#' @rdname add_files
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit

add_js_file <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  attempt::stop_if(rlang::is_missing(name),
    msg = "Name is required")
  
  old <- setwd(normalizePath(pkg))  
  on.exit(setwd(old))
  
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
  
  dir <- normalizePath(dir) 
  
  where <- file.path(
    dir, glue::glue("{name}.js")
  )
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  file.create(where)
  
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
#' @rdname add_files
add_js_handler <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  attempt::stop_if(rlang::is_missing(name),
    msg = "Name is required")
  
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
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
  
  dir <- normalizePath(dir) 
  
  where <- file.path(
    dir, glue::glue("{name}.js")
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
  write_there("  })")
  write_there("});")
  
  cat_green_tick(glue::glue("File created at {where}"))
  cat_red_bullet(
    glue::glue(
      'To link to this file,  go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$script(src="www/{name}.js")`'
    )
  )
  
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
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){
  attempt::stop_if(rlang::is_missing(name),
    msg = "Name is required")
  
  old <- setwd(normalizePath(pkg)) 
  on.exit(setwd(old))
  
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
  
  dir <- normalizePath(dir) 
  
  where <- file.path(
    dir, glue::glue("{name}.css")
  )
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  file.create(where)
  
  cat_green_tick(glue::glue("File created at {where}"))
  cat_red_bullet(
    glue::glue(
      'To link to this file,  go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$link(rel="stylesheet", type="text/css", href="www/{name}.css")`'
    )
  )
  
  if (rstudioapi::isAvailable() & open ){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(glue::glue("Go to {where}"))
  }
}


#' @export
#' @rdname add_files
#' @importFrom glue glue
add_ui_server_files <- function(
  pkg = get_golem_wd(), 
  dir = "inst/app",
  dir_create = TRUE
){
  
  #browser()
  old <- setwd(normalizePath(pkg))   
  on.exit(setwd(old))
  
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
  
  dir <- normalizePath(dir) 
  
  # UI
  where <- file.path(
    dir, "ui.R"
  )
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
  file.create(where)
  write_there <- function(...) write(..., file = where, append = TRUE)
  
  if (is.null(getOption('golem.pkg.name'))){
    pkg <- pkgload::pkg_name()
  } else {
    pkg <- getOption('golem.pkg.name')
  }
  
  write_there(
    sprintf( "%s:::app_ui()", pkg )
  )
  
  cat_green_tick(glue("ui file created at {where}"))
  
  # server
  where <- file.path(
    dir, "server.R"
  )
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
  file.create(where)
  write_there <- function(...) write(..., file = where, append = TRUE)
  
  write_there(
    sprintf(
      "%s:::app_server",
      pkg
    )
  )
  
  cat_green_tick(glue("server file created at {where}"))
  
}
