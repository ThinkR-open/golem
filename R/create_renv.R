#' Title
#'
#' @param path
#' @param dev_pkg
#' @param folder_to_include
#' @param output
#'
#' @return
#' @export
# @importFrom attachment att_from_rscripts att_from_rmds install_if_missing
# @importFrom renv snapshot
# @importFrom cli cli_bullets
#' @examples
create_renv_for_dev <- function(path=".",
                                dev_pkg = c("renv","devtools", "roxygen2", "usethis", "pkgload",
                                            "testthat","remotes", "covr", "attachment","pak","dockerfiler",
                                            "remotes::install_github('ThinkR-open/checkhelper')"),
                                folder_to_include = c("dev/","data-raw/"),
                                output = "renv.lock"
){
  check_is_installed("attachment")
  check_is_installed("renv")
  check_is_installed("dockerfiler")
  required_version("dockerfiler", "0.1.5.0001")
  
  from_r_script <-
    unlist(lapply(
      file.path(path, folder_to_include),
      attachment::att_from_rscripts
    ))
  
  
  from_rmd <-
    unlist(lapply(
      file.path(path, folder_to_include),
      attachment::att_from_rmds
    ))
  
  pkg_list <- c(
    attachment::att_from_description(),
    from_r_script,from_rmd,
    dev_pkg
  )
  pkg_list
  
  attachment::install_if_missing(pkg_list)
  cat_green_tick(sprintf("create renv.lock at %s",output))
  renv::snapshot(packages = pkg_list,lockfile = output,prompt = FALSE)
  
  output
  
}


#' @rdname create_renv_for_dev
create_renv_for_prod <-function(path=".",output = "renv.lock.prod"){
  create_renv_for_dev(path = path,dev_pkg = "remotes",folder_to_include=NULL,output = output)
}
