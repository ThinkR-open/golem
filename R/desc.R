#' Fill your description
#'
#' @param pkg_name The name of the package
#' @param pkg_title The title of the package
#' @param pkg_description Description of the package
#' @param author_first_name First Name of the author
#' @param author_last_name Last Name of the author
#' @param author_email Email of the author
#' @param repo_url URL (if needed)
#' @param pkg Path to look for the DESCRIPTION
#' 
#' @importFrom desc description
#' @importFrom glue glue
#' @importFrom cli cat_bullet
#' @export
fill_desc <- function(
  pkg_name, 
  pkg_title, 
  pkg_description,
  author_first_name, 
  author_last_name, 
  author_email, 
  repo_url = NULL,
  pkg = "."
  ){
  path <- normalizePath(pkg)
  desc <- desc::description$new(
    file = file.path(path, "DESCRIPTION")
  )
  desc$set("Authors@R", glue("person('{author_first_name}', '{author_last_name}', email = '{author_email}', role = c('cre', 'aut'))"))
  desc$del("Maintainer")
  desc$set_version("0.0.0.9000")
  desc$set(Title = pkg_title)
  desc$set(Description = pkg_description)
  if_not_null(repo_url, desc$set("URL", repo_url))
  if_not_null(repo_url, desc$set("BugReports", glue("{repo_url}/issues")))
  desc$write(file = "DESCRIPTION")
  cat_bullet("DESCRIPTION modified", bullet = "tick", bullet_col = "green")
}


if_not_null <- function(x, ...){
  if (! is.null(x)){
    force(...)
  }
}

