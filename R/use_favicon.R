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
  cat_line('golem::favicon()')
  cat_line()
  
  
  
}

#' Add favicon to your app
#' 
#' This function adds the favicon from `www/favicon.png` to your shiny app. 
#' @export
#' @importFrom htmltools tags
favicon <- function(){
  tags$head(tags$link(rel="shortcut icon", href="www/favicon.png"))
}