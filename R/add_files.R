#' Create Files
#' 
#' These functions create files inside the `inst/app` folder. 
#' These functions can be used outside of a {golem} project. 
#' 
#' @inheritParams  add_module
#' @param dir Path to the dir where the file while be created.
#' @param with_doc_ready Should the default file include `$( document ).ready()`?
#' @param template Function writing in the created file.
#' You may overwrite this with your own template function.
#' @param ... Arguments to be passed to the `template` function.
#' 
#' @export
#' @rdname add_files
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit
#' @importFrom fs path_abs path file_create file_exists
#' 
#' @note `add_ui_server_files` will be deprecated in future version of `{golem}`
#' 
#' @seealso [js_handler_template(), js_template(), css_template()]
add_js_file <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE, 
  with_doc_ready = TRUE, 
  template = golem::js_template,
  ...
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
    cat_dir_necessary()
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
      template(path = where, ...)
      write_there("});")
    } else {
      template(path = where, ...)
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
#' 
#' @importFrom fs path_abs path file_create file_exists
#' 
#' @seealso [js_handler_template()]
add_js_handler <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE,
  template = golem::js_handler_template,
  ...
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
    cat_dir_necessary()
    return(invisible(FALSE))
  }
  
  dir <- path_abs(dir) 
  
  where <- file.path(
    dir, sprintf("%s.js", name)
  )
  
  if (!file.exists(where)){
    
    file_create(where)
    
    template(path = where, ...)
    
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
#' @param initialize Whether to add the initialize method. Default to FALSE. Some JavaScript API 
#' require to initialize components before using them.
#' @param dev Whether to insert console.log calls in the most important methods of the binding.
#' This is only to help building the input binding. Default to FALSE
#' @param events List of events to generate event listeners in the subscribe method. For instance,
#' \code{list(name = c("click", "keyup"), rate_policy = c(FALSE, TRUE))}.
#' The list contain names and rate policies to apply to each event. If a rate policy is found, 
#' the debounce method with a default delay of 250 ms is applied. You may edit manually according to 
#' \url{https://shiny.rstudio.com/articles/building-inputs.html}. 
#' @importFrom fs path_abs path file_create file_exists
add_js_input_binding <- function(
  name, 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE,
  initialize = FALSE,
  dev = FALSE,
  events = list(
    name = "click",
    rate_policy = FALSE
  )
){
  attempt::stop_if(
    rlang::is_missing(name),
    msg = "Name is required"
  )
  
  attempt::stop_if(
    length(events$name) == 0,
    msg = "At least one event is required"
  )
  
  attempt::stop_if(
    length(events$name) != length(events$rate_policy),
    msg = "Incomplete events list"
  )
  
  raw_name <- name
  
  name <- file_path_sans_ext(
    sprintf("input-%s", name)
  )
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    dir, type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
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
    
    # If we find at least 1 event with a rate policy, we allow
    # the getRatePolicy method
    global_rate_policy <- sum(sapply(events$rate_policy, `[[`, 1)) > 0
    
    write_there(sprintf("var %s = new Shiny.InputBinding();", raw_name))
    write_there(sprintf("$.extend(%s, {", raw_name))
    # find
    write_there("  find: function(scope) {")
    write_there("    // JS logic $(scope).find('whatever')")
    write_there("  },")
    # initialize
    if (initialize) {
      write_there("  initialize: function(el) {")
      write_there("    // optional part. Only if the input relies on a JS API with specific initialization.")
      write_there("  },") 
    }
    # get value
    write_there("  getValue: function(el) {")
    if (dev) write_there("    console.log($(el));")
    write_there("    // JS code to get value")
    write_there("  },")
    # set value
    write_there("  setValue: function(el, value) {")
    if (dev) write_there("    console.log('New value is: ' + value);")
    write_there("    // JS code to set value")
    write_there("  },")
    # receive
    write_there("  receiveMessage: function(el, data) {")
    write_there("    // this.setValue(el, data);")
    if (dev) write_there("    console.log('Updated ...');")
    write_there("  },")
    # subscribe
    write_there("  subscribe: function(el, callback) {")
    # list of event listeners
    lapply(seq_along(events$name), function(i) {
      write_there(sprintf("    $(el).on('%s.%s', function(e) {", events$name[i], raw_name))
      if (events$rate_policy[i]) {
        write_there("      callback(true);")
      } else {
        write_there("      callback();")
      }
      if (dev) write_there("      console.log('Subscribe ...');")
      write_there("    });")
      write_there("")
    })
    write_there("  },")
    
    # rate policy if any
    if (global_rate_policy) {
      write_there("  getRatePolicy: function() {")
      write_there("    return {")
      write_there("      policy: 'debounce',")
      write_there("      delay: 250")
      write_there("    };")
      write_there("  },")
    }
    
    # unsubscribe
    write_there("  unsubscribe: function(el) {")
    write_there(sprintf("    $(el).off('.%s');", raw_name))
    write_there("  }")
    
    # end
    write_there("});")
    write_there(sprintf("Shiny.inputBindings.register(%s, 'shiny.whatever');", raw_name))
    
    
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
add_js_output_binding <- function(
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
  
  raw_name <- name
  
  name <- file_path_sans_ext(
    sprintf("output-%s", name)
  )
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    dir, type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
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
    
    # write in the file!
    
    write_there(sprintf("var %s = new Shiny.OutputBinding();", raw_name))
    write_there(sprintf("$.extend(%s, {", raw_name))
    # find
    write_there("  find: function(scope) {")
    write_there("    // JS logic $(scope).find('whatever')")
    write_there("  },")
    # renderValue
    write_there("  renderValue: function(el, data) {")
    write_there("    // JS logic")
    write_there("  }")
    # end
    write_there("});")
    write_there(sprintf("Shiny.outputBindings.register(%s, 'shiny.whatever');", raw_name))
    
    
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
  dir_create = TRUE, 
  template = golem::css_template,
  ...
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
    cat_dir_necessary()
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
    template(path = where, ...)
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
#' @importFrom fs path_abs path file_create file_exists
add_html_template <- function(
  name = "template.html", 
  pkg = get_golem_wd(), 
  dir = "inst/app/www",
  open = TRUE, 
  dir_create = TRUE
){

  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg)) 
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    dir, type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
    return(invisible(FALSE))
  }
  
  dir <- path_abs(dir) 
  
  where <- path(
    dir, sprintf(
      "%s.html", 
      name
    )
  )
  
  if (!file_exists(where)){
    file_create(where)
    write_there <- function(...) write(..., file = where, append = TRUE)
    write_there("<!DOCTYPE html>")
    write_there("<html>")
    write_there("  <head>")
    write_there(
      sprintf(
        "    <title>%s</title>", 
        get_golem_name()
      )
    )
    write_there("  </head>")
    write_there("  <body>")
    write_there("    {{ body }}")
    write_there("  </body>")
    write_there("</html>")
    write_there("")
    file_created_dance(
      where, 
      after_creation_message_html_template, 
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
  
  .Deprecated(msg = "This function will be deprecated in a future version of {golem}.\nPlease comment on https://github.com/ThinkR-open/golem/issues/445 if you want it to stay.")
  
  old <- setwd(path_abs(pkg))   
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    dir, type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
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
