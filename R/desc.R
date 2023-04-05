#' Fill your description
#'
#' @param pkg_name The name of the package
#' @param pkg_title The title of the package
#' @param pkg_description Description of the package
#' @param authors a character string (or vector) of class person
#'    (see [person()] for details)
#' @param repo_url URL (if needed)
#' @param pkg_version The version of the package. Default is 0.0.0.9000
#' @param pkg Path to look for the DESCRIPTION. Default is `get_golem_wd()`.
#'
#'
#' @export
#'
#' @return The {desc} object, invisibly.
fill_desc <- function(
  pkg_name,
  pkg_title,
  pkg_description,
  authors = c(person("Angelo",
                     "Canty",
                     role = "aut",
                     comment = "S original, <http://statwww.epfl.ch/davison/BMA/library.html>"),
                     person(c("Brian", "D."),
                     "Ripley",
                     role = c("aut", "trl", "cre"),
                     comment = "R port",
                     email = "ripley@stats.ox.ac.uk")),
  repo_url = NULL,
  pkg_version = "0.0.0.9000",
  pkg = get_golem_wd()
) {
  stopifnot(`'authors' must be of class 'person'` = inherits(authors, "person"))
  path <- fs_path_abs(pkg)

  desc <- desc_description(
    file = fs_path(path, "DESCRIPTION")
  )
  desc$set_authors(authors)

  desc$del(
    keys = "Maintainer"
  )
  desc$set_version(
    version = pkg_version
  )
  set_golem_version(
    version = pkg_version,
    pkg = path
  )
  desc$set(
    Package = as.character(pkg_name)
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

  cli_cat_bullet(
    "DESCRIPTION file modified",
    bullet = "tick",
    bullet_col = "green"
  )
  return(
    invisible(
      desc
    )
  )
}
