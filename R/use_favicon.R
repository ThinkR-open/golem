#' Add a favicon to your shinyapp
#'
#' @param path Path to your favicon file (.ico or .png) 
#' @param pkg Path to the root of the package. Default is `"."`
#'
#' @export
#' 
#' @importFrom attempt stop_if_not
#'
#' @examples
#' \dontrun{
#' use_favicon()
#' use_favicon(path='path/to/your/favicon.ico')
#' }
use_favicon <- function(path, pkg = "."){
  
  if (missing(path)){
    path <- system.file("shinyexample/inst/app/www", "favicon.ico", package = "golem")
  }
  
  ext <- tools::file_ext(path)
  stop_if_not(ext, ~ .x %in% c("png",'ico'), "favicon ust have .ico or .png extension")
  
  path <- normalizePath(path)
  
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  file.copy(overwrite = TRUE,
    path, 
    to <- file.path(normalizePath(pkg), "inst/app/www", glue::glue("favicon.{ext}"))
  )
  
  cat_bullet(glue::glue("favicon.{ext} created at {to}"), bullet = "tick", bullet_col = "green")
  
  cat_rule("To be copied in your UI")
  # cat_line('tags$head(tags$link(rel="shortcut icon", href="www/favicon.png"))')
  cat_line('# favicon()')
  cat_line()
  
  
  # TODO factoriser
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  where <- file.path( "R", "favicon.R")
  if (file.exists(where)){
    if (!yesno("File already exists, override?")){
      return(invisible(NULL))
    }
  }
  file.create(where)
  write_there <- function(...){
    write(..., file = where, append = TRUE)
  }
  glue <- function(...){
    glue::glue(..., .open = "%", .close = "%")
  }
  write_there("#' Add favicon to your app")
  write_there("#' ")
  write_there(glue("#' This function adds the favicon from `www/favicon.%ext%` to your shiny app."))
  # write_there("#' @export")
  write_there("#' @importFrom htmltools tags")
  write_there("#' @importFrom shiny addResourcePath")
  write_there("favicon <- function(){")
  write_there(glue("shiny::addResourcePath('www', system.file('app/www', package = '%read.dcf(file.path(pkg,\'DESCRIPTION\'))[1]%'))"))
  write_there(glue("tags$head(tags$link(rel='shortcut icon', href='www/favicon.%ext%'))"))
  write_there("}")
  write_there("")
  cat_bullet(glue("File created at %where%"), bullet = "tick", bullet_col = "green")
  usethis::use_package("htmltools")
}

# #' Add favicon to your app
# #' 
# #' This function adds the favicon from `www/favicon.png` to your shiny app. 
# #' @export
# #' @importFrom htmltools tags
# favicon <- function(){
#  tags$head(tags$link(rel="shortcut icon", href="www/favicon.png"))
# }