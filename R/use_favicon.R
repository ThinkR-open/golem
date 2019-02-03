#' Add a favicon to your shinyapp
#'
#' @param path Path to your favicon file (.ico or .png) 
#' @param pkg Path to the root of the package. Default is `"."`
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' use_favicon()
#' use_favicon(path='path/to/your/favicon.ico')
#' }
use_favicon <- function(path,pkg = "."){
  #<link rel="apple-touch-icon" sizes="57x57" href="/apple-icon-57x57.png">
  #<link rel="apple-touch-icon" sizes="60x60" href="/apple-icon-60x60.png">
  #<link rel="apple-touch-icon" sizes="72x72" href="/apple-icon-72x72.png">
  #<link rel="apple-touch-icon" sizes="76x76" href="/apple-icon-76x76.png">
  #<link rel="apple-touch-icon" sizes="114x114" href="/apple-icon-114x114.png">
  #<link rel="apple-touch-icon" sizes="120x120" href="/apple-icon-120x120.png">
  #<link rel="apple-touch-icon" sizes="144x144" href="/apple-icon-144x144.png">
  #<link rel="apple-touch-icon" sizes="152x152" href="/apple-icon-152x152.png">
  #<link rel="apple-touch-icon" sizes="180x180" href="/apple-icon-180x180.png">
  #<link rel="icon" type="image/png" sizes="192x192"  href="/android-icon-192x192.png">
  #<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  #<link rel="icon" type="image/png" sizes="96x96" href="/favicon-96x96.png">
  #<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  #<link rel="manifest" href="/manifest.json">
  #<meta name="msapplication-TileColor" content="#ffffff">
  #<meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
  #<meta name="theme-color" content="#ffffff">
  
  if (missing(path)){
        path <-  system.file("shinyexample\\inst\\app\\www","favicon.ico",package = "golem")
  }
  
  ext <- tools::file_ext(path)
  if ( !(ext %in% c("png",'ico') ) ){
    stop("favicon ust have .ico or .png extension")
  }
  
  path <- normalizePath(path)
  
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  file.copy(overwrite = TRUE,
    path, 
    to <- file.path(normalizePath(pkg), "inst/app/www", glue::glue("favicon.{ext}"))
  )
  
  cat_bullet(glue::glue("favicon.{ext} created at {to}"), bullet = "tick", bullet_col = "green")
  
  cat_rule("To be copied in your UI")
  cat_line('tags$head(tags$link(rel="shortcut icon", href="www/favicon.png"))')
  cat_line()
  
  
  
}