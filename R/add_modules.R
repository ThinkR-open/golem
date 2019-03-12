#' Create a module
#' 
#' This function creates a module inside the `R/` folder, based 
#' on a specific module structure. 
#' 
#' @param name The name of the module
#' @param pkg Path to the root of the package. Default is `"."`.
#' @note This function will prefix the `name` argument with `mod_`.
#' @export
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @importFrom utils file.edit

add_module <- function(name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  where <- file.path(
    "R", paste0("mod_", name, ".R")
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
  write_there("# Module UI")
  write_there("  ")
  write_there(glue("#' @title   mod_%name%_ui and mod_%name%_server"))
  write_there("#' @description  A shiny Module.")
  write_there("#'")
  write_there("#' @param id shiny id")
  write_there("#' @param input internal")
  write_there("#' @param output internal")
  write_there("#' @param session internal")
  write_there("#'")
  write_there(glue("#' @rdname mod_%name%"))
  write_there("#'")
  write_there("#' @keywords internal")
  write_there("#' @export ") 
  write_there("#' @importFrom shiny NS tagList ") 
  
  
  write_there(glue("mod_%name%_ui <- function(id){"))
  write_there("  ns <- NS(id)")
  write_there("  tagList(")
  write_there("  ")
  write_there("  )")
  write_there("}")
  write_there("    ")
  write_there("# Module Server")
  write_there("    ")
  write_there(glue("#' @rdname mod_%name%"))
  write_there("#' @export")
  write_there("#' @keywords internal")
  write_there("    ")
  write_there(glue("mod_%name%_server <- function(input, output, session){"))
  write_there("  ns <- session$ns")
  write_there("}")
  write_there("    ")
  
  write_there("## To be copied in the UI")
  write_there(glue('# mod_%name%_ui("%name%_ui_1")'))
  write_there("    ")
  write_there("## To be copied in the server")
  write_there(glue('# callModule(mod_%name%_server, "%name%_ui_1")'))
  write_there(" ")
  cat_bullet(glue("File created at %where%"), bullet = "tick", bullet_col = "green")
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue("Go to %where%"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
}