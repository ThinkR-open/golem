guess_where_config <- function(
  path
){
  # Trying the path
  path <- file.path(
    path, "inst/golem-config.yml"
  )
  if (file.exists(path)) return(normalizePath(path))
  # Trying maybe in the wd
  path <-  "golem-config.yml"
  if (file.exists(path)) return(normalizePath(path))
  # Trying with pkgpath
  path <- attempt::attempt({
    file.path(
      pkgload::pkg_path(), 
      "inst/golem-config.yml"
    )
  })
  if (
    !attempt::is_try_error(path) & 
    file.exists(path)
  ) {
    return(
      normalizePath(path)
    )
  }
  return(NULL)
}

get_current_config <- function(
  path = ".", 
  set_options = TRUE
){
  
  # We check wether we can guess where the config file is
  path_conf <- guess_where_config(path)
  # We default to inst/ if this doesn't exist
  if (is.null(path_conf)){
    path_conf <- file.path(
      path, "inst/golem-config.yml"
    )
  }
  
  if (!file.exists(path_conf)){
    ask <- yesno::yesno(
      sprintf(
        "The %s file doesn't exist, create?", 
        basename(path_conf)
      )
    )
    # Return early if the user doesn't allow 
    if (!ask) return(FALSE)
    
    fs::file_copy(
      path = golem_sys("shinyexample/inst/golem-config.yml"), 
      new_path = file.path(
        path, "inst/golem-config.yml"
      )
    )
    fs::file_copy(
      path = golem_sys("shinyexample/R/app_config.R"), 
      new_path = file.path(
        path, "R/app_config.R"
      )
    )
    replace_word(
      "R/app_config.R", 
      "shinyexample", 
      pkgload::pkg_name()
    )
    if (set_options){
      set_golem_options()
    }
  }
  
  return(path_conf)
  
}

#' Amend golem config file
#'
#' @param key key of the value to add in `config`
#' @inheritParams config::get
#' @inheritParams add_module
#' @inheritParams set_golem_options
#'
#' @export
amend_golem_config <- function(
  key,
  value, 
  config = "default", 
  pkg = get_golem_wd(), 
  talkative = TRUE
){
  conf_path <- get_current_config(pkg)
  conf <- yaml::read_yaml(conf_path)
  conf[[config]][[key]] <- value
  yaml::write_yaml(
    conf, 
    conf_path
  )
  invisible(TRUE)
}