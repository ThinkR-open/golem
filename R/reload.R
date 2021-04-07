#' Detach all attached package
#' 
#' @importFrom attempt attempt
#' @importFrom utils sessionInfo
#'
#' @export
detach_all_attached <- function(){
  all_attached <-  paste("package:", names(sessionInfo()$otherPkgs), sep = "")
  attempt(
    suppressWarnings(
      invisible(lapply(
        all_attached,
        detach, 
        character.only = TRUE, 
        unload = TRUE
      )
      )
    ), 
    silent = TRUE
  )
  return(invisible(TRUE))
}

check_name_consistency <- function(
  pkg 
){
  
  old_dir <- setwd(pkg)
  
  package_name <- desc::desc_get("Package")
  pth <- fs::path(pkg, "R", "app_config.R")
  app_config <- readLines(pth) 
  
  where_system.file <- app_config[
    grep("system.file", app_config)
  ]
  
  setwd(old_dir)
  
  if (grepl(
    package_name, 
    where_system.file
  )){
    
    return(invisible(TRUE))
  } else {
    stop(
      call. = FALSE,
      "Package name does not match in DESCRIPTION and `app_sys()`.\n",
      "\n", 
      sprintf(
        "DESCRIPTION: '%s'\n", package_name
      ),
      sprintf(
        "R/app_config.R - app_sys(): '%s'\n", where_system.file
      ), 
      "\n", 
      sprintf(
        "Please make both these names match before continuing, for example using golem::set_golem_name('%s')",
        package_name
      )
    )
  }
  
}




#' Document and reload your package
#' 
#' This function calls \code{rstudioapi::documentSaveAll()}, 
#' \code{roxygen2::roxygenise()} and \code{pkgload::load_all()}.
#'
#' @inheritParams add_module
#' @inheritParams roxygen2::roxygenise
#' @inheritParams pkgload::load_all
#' @param ... Other arguments passed to `pkgload::load_all()`
#' @importFrom roxygen2 roxygenise
#' @importFrom pkgload load_all
#' @export
document_and_reload <- function(
  pkg = get_golem_wd(), 
  roclets = NULL, 
  load_code = NULL, 
  clean = FALSE, 
  export_all = FALSE,
  helpers = FALSE,
  attach_testthat = FALSE, 
  ...
){
  # We'll start by checking if the package name is correct
  
  check_name_consistency(pkg)
  
  if (rstudioapi::hasFun("documentSaveAll")) {
    rstudioapi::documentSaveAll()
  }
  roxed <- try({
    roxygenise(
      package.dir = pkg, 
      roclets = roclets, 
      load_code =load_code,
      clean = clean
    )
  })
  if (attempt::is_try_error(roxed)){
    cli::cat_rule(
      "Error documenting your package"
    )
    dialog_if_has("Alert", "Error documenting your package")
    return(invisible(FALSE))
  }
  loaded <- try({
    load_all(
      pkg,
      export_all = export_all,
      helpers = helpers,
      attach_testthat = attach_testthat, 
      ...
    )
  })
  
  if (attempt::is_try_error(loaded)){
    cli::cat_rule(
      "Error loading your package"
    )
    dialog_if_has("Alert", "Error loading your package")
    return(invisible(FALSE))
  }
  
}

dialog_if_has <- function(title, message, url = ""){
  if (rstudioapi::hasFun("showDialog")) {
    rstudioapi::showDialog(title, message, url)
  }
}
