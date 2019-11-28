#' @importFrom tools file_path_sans_ext
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
    module <- paste0("mod_", module, "_")
  }
  where <- path(
    "R", paste0(module, ext, "_", name, ".R")
  )
  
  file_create(where)
  
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
#' @param module If not NULL, the file will be module specific in the naming (you don't need to add the leading `mod_`)
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
    pkg = pkg, 
    open = open, 
    dir_create = dir_create
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
    pkg = pkg, 
    open = open, 
    dir_create = dir_create
  )
}