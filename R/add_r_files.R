add_r_files <- function(
  name, 
  ext = c("fct", "utils"),
  module = "",
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE
){
  old <- setwd(normalizePath(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_dir_if_needed(
    "R", 
    dir_create
  )
  if (!dir_created){
    cat_red_bullet(
      "File not added (needs a valid directory)"
    )
    return(invisible(FALSE))
  }
  if (!is.null(module)){
    module <- paste0(module, "_")
  }
  where <- file.path(
    "R", paste0(module, ext, "_", name, ".R")
  )
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  file.create(where)
  
  if (rstudioapi::isAvailable() & open){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue("Go to {where}"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
}

#' Add fct_ and utils_ files
#' 
#' These function adds files in the R/ folder 
#' that starts either with fct_ or with utils_
#'
#' @param name The name of the file
#' @param module If not NULL, the file will be module specific in the naming.
#' @param pkg The working directory 
#' @param open Should the file be opened once created? 
#' @param dir_create Should the folder be created if it doesn't exist? 
#' 
#' @rdname file_creation
#' @export
add_fct <- function(
  name, 
  module = NULL,
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE
){
  add_r_files(
    name, 
    module,
    ext = "fct",
    pkg = get_golem_wd(), 
    open = TRUE, 
    dir_create = TRUE
  )
}

#' @rdname file_creation
#' @export
add_utils<- function(
  name, 
  module = NULL,
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE
){
  add_r_files(
    name, 
    module,
    ext = "utils",
    pkg = get_golem_wd(), 
    open = TRUE, 
    dir_create = TRUE
  )
}