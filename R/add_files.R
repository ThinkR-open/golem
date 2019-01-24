#' Create a module
#' 
#' @param name The name of the module
#' @param pkg Path to the root of the package. Default is `"."`
#' 
#' @export
#' @importFrom glue glue

add_module <- function(name, pkg = "."){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  where <- file.path(
    "R", paste0("mod_", name, ".R")
  )
  file.create(where)
  write_there <- function(...){
    write(..., file = where, append = TRUE)
  }
  glue <- function(...){
    glue::glue(..., .open = "%", .close = "%")
  }
  write_there("# mod_UI")
  write_there(glue("%name%ui <- function(id){"))
  write_there("  ns <- NS(id)")
  write_there("  tagList(")
  write_there("  ")
  write_there("  )")
  write_there("}")
  write_there("    ")
  write_there(glue("%name% <- function(input, output, session){"))
  write_there("  ns <- session$ns")
  write_there("}")
  write_there("    ")
  write_there("# To be copied in the UI")
  write_there(glue('%name%ui("%name%ui")'))
  write_there("    ")
  write_there("# To be copied in the server")
  write_there(glue('callModule(%name%, "%name%ui")'))
  write_there(" ")
  file.edit(where)
}

#' Add an app.R at the root of your package to deploy on RStudio Connect
#'
#' @inheritParams add_module
#'
#' @export
add_rconnect_file <- function(pkg = "."){
  where <- file.path(pkg, "app.R")
  file.create( where )
  usethis::use_build_ignore( where )
  write("pkgload::load_all()", where)
  write("run_app()", where)
  file.edit( where )
}
