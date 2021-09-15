#' Create a module
#' 
#' This function creates a module inside the `R/` folder, based 
#' on a specific module structure. This function can be used outside
#' of a `{golem}` project.
#' 
#' @param name The name of the module.
#' @param pkg Path to the root of the package. Default is `get_golem_wd()`.
#' @param open Should the created file be opened?
#' @param dir_create Creates the directory if it doesn't exist, default is `TRUE`.
#' @param fct If specified, creates a `mod_fct` file.
#' @param utils If specified, creates a `mod_utils` file.
#' @param js,js_handler If specified, creates a module related JavaScript file.
#' @param export Should the module be exported? Default is `FALSE`.
#' @param module_template Function that serves as a module template.
#' @param ... Arguments to be passed to the `module_template` function.
#' 
#' @note This function will prefix the `name` argument with `mod_`.
#' 
#' @export
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit
#' @importFrom fs path_abs path file_create
#' 
#' @seealso [module_template()]
#' 
#' @return The path to the file, invisibly.
add_module <- function(
  name, 
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE, 
  fct = NULL, 
  utils = NULL,
  js = NULL,
  js_handler = NULL,
  export = FALSE, 
  module_template = golem::module_template, 
  ...
){
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    path(pkg, "R"), type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
    return(invisible(FALSE))
  }
  
  if (!is.null(fct)){
    add_fct(fct, module = name, open = open)
  }
  
  if (!is.null(utils)){
    add_utils(utils, module = name, open = open)
  }
  
  if (!is.null(js)){
    add_js_file(js, pkg = pkg, open = open)
  }
  
  if (!is.null(js_handler)){
    add_js_handler(js_handler, pkg = pkg, open = open)
  }
  
  where <- path(
    "R", paste0("mod_", name, ".R")
  )
  
  if (!file_exists(where)){
    file_create(where)
    
    module_template(name = name, path = where, export = export, ...)
    
    #write_there(" ")
    cat_created(where)
    open_or_go_to(where, open)
  } else {
    file_already_there_dance(
      where = where, 
      open_file = open
    )
  }
}

#' Golem Module Template Function
#' 
#' Module template can be used to extend golem module creation 
#' mechanism with your own template, so that you can be even more 
#' productive when building your `{shiny}` app. 
#' Module template functions do not aim at being called as is by 
#' users, but to be passed as an argument to the `add_module()` 
#' function.
#' 
#' Module template functions are a way to define your own template
#' function for module. A template function that can take the following
#' arguments to be passed from `add_module()`: 
#' + name: the name of the module
#' + path: the path to the file in R/
#' + export: a TRUE/FALSE set by the `export` param of `add_module()`
#' 
#' If you want your function to ignore these parameters, set `...` as the
#' last argument of your function, then these will be ignored. See the examples
#' section of this help. 
#' 
#' @examples 
#' 
#' if (interactive()){
#'   my_tmpl <- function(name, path, ...){
#'       # Define a template that write to the 
#'       # module file
#'       write(name, path)
#'   }
#'   golem::add_module(name = "custom", module_template = my_tmpl)
#'   
#'   my_other_tmpl <- function(name, path, ...){
#'       # Copy and paste a file from somewhere
#'       file.copy(..., path)
#'   }
#'   golem::add_module(name = "custom", module_template = my_other_tmpl)
#' }
#'
#' @inheritParams add_module
#' @param path The path to the R script where the module will be written. 
#' Note that this path will not be set by the user but via
#' `add_module()`. 
#' @param ph_ui,ph_server Texts to insert inside the modules UI and server. 
#'     For advanced use.
#'
#' @return Used for side effect
#' @export
#' @seealso [add_module()]
module_template <- function(
  name, 
  path, 
  export, 
  ph_ui = " ", 
  ph_server = " ",
  ...
){
  write_there <- function(...){
    write(..., file = path, append = TRUE)
  }
  
  write_there(sprintf("#' %s UI Function", name))
  write_there("#'")
  write_there("#' @description A shiny Module.")
  write_there("#'")
  write_there("#' @param id,input,output,session Internal parameters for {shiny}.")
  write_there("#'")
  if (export){
    write_there(sprintf("#' @rdname mod_%s", name))
    write_there("#' @export ") 
  } else {
    write_there("#' @noRd ") 
  }
  write_there("#'")
  write_there("#' @importFrom shiny NS tagList ") 
  write_there(sprintf("mod_%s_ui <- function(id){", name))
  write_there("  ns <- NS(id)")
  write_there("  tagList(")
  write_there(ph_ui)
  write_there("  )")
  write_there("}")
  write_there("    ")
  
  if (utils::packageVersion("shiny") < "1.5"){
    
    write_there(sprintf("#' %s Server Function", name))
    write_there("#'")
    if (export){
      write_there(sprintf("#' @rdname mod_%s", name))
      write_there("#' @export ") 
    } else {
      write_there("#' @noRd ") 
    }
    write_there(sprintf("mod_%s_server <- function(input, output, session){", name))
    write_there("  ns <- session$ns")
    write_there(ph_server)
    write_there("}")
    write_there("    ")
    
    write_there("## To be copied in the UI")
    write_there(sprintf('# mod_%s_ui("%s_1")', name, name))
    write_there("    ")
    write_there("## To be copied in the server")
    write_there(sprintf('# callModule(mod_%s_server, "%s_1")', name, name))
    
    
  } else {
    
    write_there(sprintf("#' %s Server Functions", name))
    write_there("#'")
    if (export){
      write_there(sprintf("#' @rdname mod_%s", name))
      write_there("#' @export ") 
    } else {
      write_there("#' @noRd ") 
    }
    write_there(sprintf("mod_%s_server <- function(id){", name))
    write_there("  moduleServer( id, function(input, output, session){")
    write_there("    ns <- session$ns")
    write_there(ph_server)
    write_there("  })")
    write_there("}")
    write_there("    ")
    
    write_there("## To be copied in the UI")
    write_there(sprintf('# mod_%s_ui("%s_1")', name, name))
    write_there("    ")
    write_there("## To be copied in the server")
    write_there(sprintf('# mod_%s_server("%s_1")', name, name))
    
  }
}