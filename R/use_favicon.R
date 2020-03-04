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
  if ( missing(path) ){
    path <- golem_sys("shinyexample/inst/app/www", "favicon.ico")
  } 
  
  ext <- file_ext(path)
  
  stop_if_not(
    ext, 
    ~ .x %in% c("png",'ico'), 
    "favicon must have .ico or .png extension"
  )
  
  
  local <- fs::file_exists(path)
  
  if ( !local ){
    
    try_online <- attempt::attempt(
      curlGetHeaders(path), 
      silent = TRUE
    )
    attempt::stop_if(
      try_online,
      attempt::is_try_error, 
      "Provided path is neither a local path nor a reachable url."
    )
    
    attempt::stop_if_not(
      attr(try_online, 'status'),
      ~ .x == 200, 
      "Unable to reach provided url (response code is not 200)."
    )
    
    destfile <- tempfile(
      fileext = paste0(".",ext),
      pattern = "favicon"
    )
    
    download.file(
      path, 
      destfile, 
      method = method
    )
    path <- path_abs(destfile)
  }
  
  old <- setwd( path_abs(pkg) )
  
  on.exit( setwd(old) )
  
  to <- path(
    path_abs(pkg), 
    "inst/app/www",
    sprintf(
      "favicon.%s", 
      ext
    )
  )
  
  if (! (path == to) ) {
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
  
  cat_line(
    "Favicon is automatically linked in app_ui via `golem_add_external_resources()`"
  )
  cat_red_bullet(
    sprintf(
      "No file found at %s", 
      path
    )
  )
  
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
#' @param resources_path prefix of the resource path of the app
#' @inheritParams add_modules
#'
#' @export
#' @importFrom htmltools tags
favicon <- function( 
  ico, 
  rel="shortcut icon", 
  resources_path = "www", 
  pkg = get_golem_wd()
){
  if (missing(ico)){
    ici <- list.files( 
      pattern = "favicon", 
      fs::path(
        pkg, 
        "inst/app/www"
      )
    )
    attempt::stop_if(
      length(ici), 
      ~ .x > 2, 
      "You have 2 favicons inside your app/www folder, please remove one."
    )
    ico <- fs::path(
      resources_path, 
      ici 
    )
  }
  tags$head(
    tags$link(
      rel = rel, 
      href = ico
    )
  )
}
