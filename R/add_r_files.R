#' @importFrom fs path_abs path file_create
add_r_files <- function(
  name, 
  ext = c("fct", "utils"),
  module = "",
  pkg = get_golem_wd(), 
  open = TRUE, 
  dir_create = TRUE
){
  
  name <- file_path_sans_ext(name)
  
  old <- setwd(path_abs(pkg))
  on.exit(setwd(old))
  
  dir_created <- create_if_needed(
    "R", type = "directory"
  )
  
  if (!dir_created){
    cat_dir_necessary()
    return(invisible(FALSE))
  }
  if (!is.null(module)){
    module <- paste0("mod_", module, "_")
  }
  where <- path(
    "R", paste0(module, ext, "_", name, ".R")
  )
  
  file_create(where)

  if(file_exists(where) & is.null(module)) {
    # Must be a function or utility file being created
    append_roxygen_comment(name = name, path = where, ext = ext)
  }

  cat_created(where)
  open_or_go_to(where, open)
  
}

#' Add fct_ and utils_ files
#' 
#' These function adds files in the R/ folder 
#' that starts either with fct_ or with utils_
#'
#' @param name The name of the file
#' @param module If not NULL, the file will be module specific in the naming (you don't need to add the leading `mod_`)
#' @param pkg The working directory. Default is `get_golem_wd()`.
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
    pkg = pkg, 
    open = open, 
    dir_create = dir_create
  )
}

#' @rdname file_creation
#' @export
add_utils <- function(
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
    pkg = pkg, 
    open = open, 
    dir_create = dir_create
  )
}

#' Append roxygen comments to fct_ and utils_ files
#' 
#' This function as boilerplate roxygen comments 
#' for fct_ and utils_ files
#'
#' @param name The name of the file
#' @param path The path to the R script where the module will be written. 
#' @param ext A string denoting the type of file to be created. 
#' 
#' @rdname file_creation
#' @noRd
append_roxygen_comment <- function(name, path, ext) {
  write_there <- function(...){
    write(..., file = path, append = TRUE)
  }

  file_type = " "

  if(ext == "utils") {
    file_type = "utility"
  } else {
    file_type = "function"
  }
  
  write_there(sprintf("#' %s %s", name, file_type))
  write_there("#'")
  write_there(sprintf("#' @description A shiny %s", file_type))
  write_there("#'")
  write_there(sprintf("#' @param Internal parameters for the %s.", file_type))
  write_there("#'")
  write_there(sprintf("#' @return The return value, if any, from executing the %s.", file_type))
  write_there("#'")
  write_there("#' @export")
}