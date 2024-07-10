#' Enable documentation generation using roxygen2
#'
#' @param path to to Rproj file
#' @noRd
#'
enable_roxygenize <- function(
  path = list.files(
    path = ".",
    pattern = "Rproj$",
    full.names = TRUE
  )[1]
) {
  cli_cat_bullet(
    sprintf("Reading %s content ", basename(path)),
    bullet = "info",
    bullet_col = "green"
  )
  source <- yaml::read_yaml(file = path)
  cli_cat_bullet(
    "Enable roxygen2",
    bullet = "info",
    bullet_col = "green"
  )
  source[["PackageRoxygenize"]] <- "rd,collate,namespace"
  yaml::write_yaml(x = source, file = path)

  cat_green_tick("Done")
}
