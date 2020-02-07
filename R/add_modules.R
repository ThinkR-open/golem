#' Create a module
#' 
#' This function creates a module inside the `R/` folder, based 
#' on a specific module structure. This function can be used outside
#' of a {golem} project.
#' 
#' @param name The name of the module
#' @param pkg Path to the root of the package. Default is `"."`.
#' @param open Should the file be opened?
#' @param dir_create Creates the directory if it doesn't exist, default is `TRUE`.
#' @param fct The name of the fct file.
#' @param utils The name of the utils file.
#' @param export Logical. Should the module be exported? Default is `FALSE`.
#' @param ph_ui,ph_server Texts to insert inside the modules UI and server. For advanced use.
#' @note This function will prefix the `name` argument with `mod_`.
#' @export
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit
#' @importFrom fs path_abs path file_create
add_module <- function(
  name, 
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE, 
  fct = NULL, 
  utils = NULL, 
  export = FALSE, 
  ph_ui = " ",
  ph_server = " "
){
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    path(pkg, "R"), type = "directory"
  )
  
  if (!dir_created){
    cat_red_bullet(
      "File not added (needs a valid directory)"
    )
    return(invisible(FALSE))
  }
  
  if (!is.null(fct)){
    add_fct(fct, module = name, open = open)
  }
  
  if (!is.null(utils)){
    add_utils(utils, module = name, open = open)
  }
  
  where <- path(
    "R", paste0("mod_", name, ".R")
  )
  
  file_create(where)
  
  write_there <- function(...){
    write(..., file = where, append = TRUE)
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
  write_there(sprintf('# mod_%s_ui("%s_ui_1")', name, name))
  write_there("    ")
  write_there("## To be copied in the server")
  write_there(sprintf('# callModule(mod_%s_server, "%s_ui_1")', name, name))
  write_there(" ")
  cat_created(where)
  open_or_go_to(where, open)
}
