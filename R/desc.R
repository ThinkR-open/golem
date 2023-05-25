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
#' @param author_first_name to be deprecated: use character for first name via
#'    \code{authors = person(given = "authors_first_name")} instead
#' @param author_last_name  to be deprecated: use character for last name via
#'    \code{authors = person(given = "authors_last_name")} instead
#' @param author_email  to be deprecated: use character for first name via
#'    \code{authors = person(email = "author_email")} instead
#' @param author_orcid  to be deprecated
#' @param set_options logical; if \code{TRUE} then [set_golem_options()] is run,
#'    which is the default; if \code{FALSE} then running [set_golem_options()]
#'    manually at some point is strongly recommended
#'
#' @export
#' @importFrom utils person
#'
#' @return The {desc} object, invisibly.
fill_desc <- function(
  pkg_name,
  pkg_title,
  pkg_description,
  authors = person(
    given = NULL,
    family = NULL,
    email = NULL,
    role = NULL,
    comment = NULL
  ),
  repo_url = NULL,
  pkg_version = "0.0.0.9000",
  pkg = get_golem_wd(),
  author_first_name = NULL,
  author_last_name = NULL,
  author_email = NULL,
  author_orcid = NULL,
  set_options = TRUE
) {

  stopifnot(`'authors' must be of class 'person'` = inherits(authors, "person"))

  # Handling retrocompatibility

  # Case 1 : old author params are not null
  any_author_params_is_not_null <- all(
    vapply(
      list(
        author_first_name,
        author_last_name,
        author_email,
        author_orcid
      ), is.null, logical(1)
    )
  )

  if (!any_author_params_is_not_null) {
    warning("The `author_first_name`, `author_last_name`, `author_email` and `author_orcid` parameters will be deprecated from fill_desc() in the next version of {golem}. \nPlease use the `authors` parameter instead.\nSee ?person for more details on how to use it.")
    # Case 1.1 : old author params are null and authors is empty
    if (length(authors) == 0) {
      # We use the old author params to fill the DESCRIPTION file
      cli_cli_alert_info(
        "the `authors` argument is empty, using `author_first_name`, `author_last_name`, `author_email` and `author_orcid` to fill the DESCRIPTION file."
      )
      authors <- person(
        given = author_first_name,
        family = author_last_name,
        email = author_email,
        role = NULL,
        comment = c(ORCID = author_orcid)
      )
    } else {
      # Case 1.2, old author params are null and authors is not empty
      # We keep the authors as is
      cli_cli_alert_info(
        "the `authors` argument is not empty, using it to fill the DESCRIPTION file, the old author params are ignored."
      )
    }
  }
  # the else here is the case 2 : old author params are null and authors is set, we keep the authors as is

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

  if (isTRUE(set_options)) set_golem_options()

  return(
    invisible(
      desc
    )
  )
}
