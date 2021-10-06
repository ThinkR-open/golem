#' @importFrom attempt attempt is_try_error
#' @importFrom pkgload pkg_path
#' @importFrom fs path path_abs
guess_where_config <- function(
  path = "."
){
  # Trying the path
  ret_path <- path( 
    path, "inst/golem-config.yml"
  )
  if (file_exists(ret_path)) return(path_abs(ret_path))
  # Trying maybe in the wd
  ret_path <-  "golem-config.yml"
  if (file_exists(ret_path)) return(path_abs(ret_path))
  # Trying with pkgpath
  ret_path <- attempt({
    path(
      pkg_path(), 
      "inst/golem-config.yml"
    )
  })
  if (
    !is_try_error(ret_path) & 
    file_exists(ret_path)
  ) {
    return(
      path_abs(ret_path)
    )
  }
  return(NULL)
}

#' @importFrom fs file_copy path
#' @importFrom pkgload pkg_name
get_current_config <- function(
  path = ".", 
  set_options = TRUE
){
  
  # We check wether we can guess where the config file is
  path_conf <- guess_where_config(path) 
  # We default to inst/ if this doesn't exist
  if (is.null(path_conf)){
    path_conf <- path(
      path, "inst/golem-config.yml"
    )
  }
  
  if (!file_exists(path_conf)){
    ask <- yesno(
      sprintf(
        "The %s file doesn't exist, create?", 
        basename(path_conf)
      )
    )
    # Return early if the user doesn't allow 
    if (!ask) return(NULL)
    
    file_copy(
      path = golem_sys("shinyexample/inst/golem-config.yml"), 
      new_path = path(
        path, "inst/golem-config.yml"
      )
    )
    file_copy(
      path = golem_sys("shinyexample/R/app_config.R"), 
      new_path = file.path(
        path, "R/app_config.R"
      )
    )
    replace_word(
      path(
        path, "R/app_config.R"
      ), 
      "shinyexample", 
      pkg_name()
    )
    if (set_options){
      set_golem_options()
    }
  }
  
  return(
    invisible(path_conf)
  )
  
}

change_app_config_name <- function(
  name, 
  path = get_golem_wd()
){
  pth <- fs::path(path, "R", "app_config.R")
  app_config <- readLines(pth) 
  
  where_system.file <- grep("system.file", app_config)
  
  app_config[
    where_system.file
  ] <- sprintf(
    '  system.file(..., package = "%s")', 
    name
  )
  write(app_config, pth )
}

# find and tag expressions in a yaml
# used internally in `amend_golem_config`

find_and_tag_exprs <- function(conf_path) {
  conf <- yaml::read_yaml(conf_path, eval.expr = FALSE)
  conf.eval <- yaml::read_yaml(conf_path, eval.expr = TRUE)
  
  expr_list <- lapply(names(conf), function(x) {
    conf[[x]][!conf[[x]] %in% conf.eval[[x]] ]
  })
  names(expr_list) <- names(conf)
  expr_list <- Filter(function(x) length(x) > 0, expr_list)
  add_expr_tag <- function(tag) {
    attr(tag[[1]], "tag") = "!expr"
    tag
  }
  tagged_exprs <- lapply(expr_list, add_expr_tag)
  modifyList(conf, tagged_exprs)
}

#' Amend golem config file
#'
#' @param key key of the value to add in `config`
#' @inheritParams config::get
#' @inheritParams add_module
#' @inheritParams set_golem_options
#' 
#' @export
#' @importFrom yaml read_yaml write_yaml
#' @importFrom attempt stop_if
#' 
#' @return Used for side effects.
amend_golem_config <- function(
  key,
  value, 
  config = "default", 
  pkg = get_golem_wd(), 
  talkative = TRUE
){
  conf_path <- get_current_config(pkg)
  stop_if(
    conf_path, 
    is.null, 
    "Unable to retrieve golem config file."
  )
  conf <- find_and_tag_exprs(conf_path)
  conf[[config]][[key]] <- value
  write_yaml(
    conf, 
    conf_path
  )
  invisible(TRUE)
}
