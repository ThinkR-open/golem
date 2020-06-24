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
  
  if (!file.exists(where)){
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
  } else {
    file_already_there_dance(
     where = where, 
      open_file = open
    )
  }
  
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
  
  if (!file.exists(where)){
    
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
      open_file = open
    )
  } else {
    file_already_there_dance(
      where, 
      open_file = open
    )
  }
  
  
  
}





#' @export
#' @rdname add_files
#' @param initialize Whether to add the initialize method. Default to FALSE.
#' @param rate_policy Whether to apply rate policy to callback method. Default
#' to FALSE.
#' @importFrom fs path_abs path file_create file_exists
add_js_binding <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE,
  initialize = FALSE, 
  rate_policy = FALSE
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
  
  if (!file.exists(where)){
    
    file_create(where)
    
    write_there <- function(...){
      write(..., file = where, append = TRUE)
    }
    
    write_there(sprintf("var %s = new Shiny.InputBinding();", name))
    write_there(sprintf("$.extend(%s, {", name))
    # find
    write_there("  find: function(scope) {")
    write_there("    // JS logic $(scope).find('whatever')")
    write_there("  },")
    # initialize
    if (initialize) {
      write_there("  initialize: function(el) {")
      write_there("    // optional part. Only if the input relies on the JS API with specific initialisation")
      write_there("  },") 
    }
    # get value
    write_there("  getValue: function(el) {")
    write_there("    // JS code to get value")
    write_there("  },")
    # set value
    write_there("  setValue: function(el, value) {")
    write_there("    // JS code to set value")
    write_there("  },")
    # receive
    write_there("  receiveMessage: function(el, data) {")
    write_there("    // this.setValue(el, data);")
    write_there("  },")
    # subscribe
    write_there("  subscribe: function(el, callback) {")
    write_there(sprintf("    $(el).on('event.%s', function(event) {", name))
    if (rate_policy) {
      write_there("      callback(true);")
    } else {
      write_there("      callback();")
    }
    write_there("    });")
    write_there("  },")
    
    # rate policy if any
    if (rate_policy) {
      write_there("  getRatePolicy: function() {")
      write_there("    return {")
      write_there("      policy: 'debounce',")
      write_there("      delay: 250")
      write_there("    };")
      write_there("  },")
    }
    
    # unsubscribe
    write_there("  unsubscribe: function(el) {")
    write_there(sprintf("    $(el).off('.%s');", name))
    write_there("  }")
    
    # end
    write_there("});")
    write_there(sprintf("Shiny.inputBindings.register(%s, 'shiny.whatever');", name))
    
    
    file_created_dance(
      where, 
      after_creation_message_js, 
      pkg, 
      dir, 
      name,
      open_file = open
    )
  } else {
    file_already_there_dance(
      where, 
      open_file = open
    )
  }
  
  
  
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
  
  if (!file_exists(where)){
    file_create(where)
    file_created_dance(
      where, 
      after_creation_message_css, 
      pkg, 
      dir, 
      name,
      open
    )
  } else {
    file_already_there_dance(
      where = where, 
      open_file = open
    )
  }
  
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
  
  if (!file_exists(where)){
    file_create(where)
    
    write_there <- function(...) write(..., file = where, append = TRUE)
    
    pkg <- get_golem_name()
    
    write_there(
      sprintf( "%s:::app_ui()", pkg )
    )
    
    cat_created(where, "ui file")
  } else {
    cat_green_tick("UI file already exists.")
  }
  
  # server
  where <- file.path(
    dir, "server.R"
  )
  
  
  if (!file_exists(where)){
    file_create(where)
    
    write_there <- function(...) write(..., file = where, append = TRUE)
    
    write_there(
      sprintf(
        "%s:::app_server",
        pkg
      )
    )
    cat_created(where, "server file")
  } else {
    cat_green_tick("server file already exists.")
  }
  
}
