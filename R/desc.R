#' Fill your description
#'
#' @param pkg_name The name of the package
#' @param pkg_title The title of the package
#' @param pkg_description Description of the package
#' @param author_first_name First Name of the author
#' @param author_last_name Last Name of the author
#' @param author_email Email of the author
#' @param repo_url URL (if needed)
#' @param pkg Path to look for the DESCRIPTION. Default is `get_golem_wd()`.
#' 
#' @importFrom desc description
#' @importFrom cli cat_bullet
#' @importFrom fs path path_abs
#' @export
fill_desc <- function(
  pkg_name, 
  pkg_title, 
  pkg_description,
  author_first_name, 
  author_last_name, 
  author_email, 
  repo_url = NULL,
  pkg = get_golem_wd()
){
  
  path <- path_abs(pkg)
  
  desc <- desc::description$new(
    file = path(path, "DESCRIPTION")
  )
  
  desc$set(
    "Authors@R", 
    sprintf(
      "person('%s', '%s', email = '%s', role = c('cre', 'aut'))", 
      author_first_name, 
      author_last_name,
      author_email
    )
  )
  desc$del(
    keys = "Maintainer"
  )
  desc$set_version(
    version = "0.0.0.9000"
  )
  set_golem_version(
    version = "0.0.0.9000", 
    path = path
  )
  desc$set(
    Package = pkg_name
  )
  change_app_config_name(
    name = pkg_name,
    path = pkg
  )
  set_golem_name(pkg_name)
  
  desc$set(
    Title = pkg_title
  )
  desc$set(
    Description = pkg_description
  )
  if_not_null(
    repo_url, 
    desc$set(
      "URL", 
      repo_url
    )
  )
  if_not_null(
    repo_url, 
    desc$set(
      "BugReports", 
      sprintf(
        "%s/issues", 
        repo_url
      )
    )
  )
  
  desc$write(
    file = "DESCRIPTION"
  )
  
  cat_bullet(
    "DESCRIPTION file modified", 
    bullet = "tick", 
    bullet_col = "green"
  )
}

