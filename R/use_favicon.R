#' Add a favicon to your shinyapp
#'
#' @param path Path to your favicon file (.ico or .png) 
#' @param pkg Path to the root of the package. Default is `get_golem_wd()`
#' @param method Method to be used for downloading files, 'curl' is default see [utils::download.file]
#' @rdname favicon
#' @export
#' 
#' @importFrom attempt stop_if_not
#' @importFrom fs path_abs path file_copy
#' @importFrom tools file_ext
#'
#' @examples
#' \donttest{
#' if (interactive()){
#'   use_favicon()
#'   use_favicon(path='path/to/your/favicon.ico')
#' }
#' }
use_favicon <- function(
  path, 
  pkg = get_golem_wd(),
  method = "curl"
){
  if (missing(path)){
    path <- golem_sys("shinyexample/inst/app/www", "favicon.ico")
  } 
  
  ext <- file_ext(path)
  stop_if_not(
    ext, 
    ~ .x %in% c("png",'ico'), 
    "favicon must have .ico or .png extension"
  )
  
  
  local <- file.exists(path)
  
  if ( !local ){
  x <- attempt::attempt(curlGetHeaders(path), silent = TRUE)
  # > attempt::is_try_error(x)
   if ( attr(x, 'status') == 200 ){
  
  destfile <- tempfile(fileext = paste0(".",ext),pattern = "favicon")
  download.file(path, destfile , method = method)
  path <- path_abs(destfile)
   } else {
     return(stop("can't reach the favicon, check your internet connection"))
   }
  }
  
  
  if ( !file_exists(path) ){
    return(stop("can't reach the favicon, check your internet connection"))
    
    
  }
  
  
  # path <- path_abs(path)
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  to <- path(
    path_abs(pkg), 
    "inst/app/www",
    sprintf(
      "favicon.%s", 
      ext
    )
  )
  
  if (! (path == to)) {
    file_copy(
      path, 
      to, 
      overwrite = TRUE
    )
    cat_green_tick(
      sprintf(
        "favicon.%s created at %s", 
        ext, 
        to
      )
    )
  }
  
  cat_rule("Change / Add in the app_ui function")
  cat_line(
    darkgrey(
      sprintf(
        'golem::favicon("www/favicon.%s")', 
        ext
      )
    )
  )
  cat_line()
  
}

#' @rdname favicon
#' @export 
#' @importFrom fs file_delete file_exists
remove_favicon <- function(
  path = "inst/app/www/favicon.ico"
){
  if (file_exists(path)){
    cat_green_tick(
      sprintf(
        "Removing favicon at %s", 
        path
      )
    )
    file_delete(path)
  } else {
    cat_red_bullet(
      sprintf(
        "No file found at %s", 
        path
      )
    )
  }
}

#' Add favicon to your app
#'
#' This function adds the favicon from `ico` to your shiny app.
#' 
#' @param ico path to favicon file
#' @param rel rel
#'
#' @export
#' @importFrom htmltools tags
favicon <- function( ico = "www/favicon.ico", rel="shortcut icon" ){
  tags$head(tags$link(rel= rel, href= ico))
}
