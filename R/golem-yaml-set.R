#' @export
#' @rdname golem_opts
set_golem_wd <- function(
  golem_wd = golem::pkg_path(),
  pkg = golem::pkg_path(),
  talkative = TRUE
) {
  if (
    golem_wd == "golem::pkg_path()" |
      normalizePath(golem_wd) == normalizePath(golem::pkg_path())
  ) {
    golem_yaml_path <- "golem::pkg_path()"
    attr(golem_yaml_path, "tag") <- "!expr"
  } else {
    golem_yaml_path <- fs_path_abs(golem_wd)
  }

  amend_golem_config(
    key = "golem_wd",
    value = golem_yaml_path,
    config = "dev",
    pkg = pkg,
    talkative = talkative
  )

  invisible(golem_yaml_path)
}

#' @export
#' @rdname golem_opts
set_golem_name <- function(
  name = golem::pkg_name(),
  pkg = golem::pkg_path(),
  talkative = TRUE,
  old_name = golem::pkg_name()
) {
  pkg <- fs_path_abs(pkg)

  # Changing in YAML
  amend_golem_config(
    key = "golem_name",
    value = name,
    config = "default",
    pkg = pkg,
    talkative = talkative
  )

  # Changing in app_config.R
  change_app_config_name(
    name = name,
    pkg = pkg
  )

  # Changing in DESCRIPTION
  desc <- desc_description(
    file = fs_path(
      pkg,
      "DESCRIPTION"
    )
  )
  desc$set(
    Package = name
  )
  desc$write(
    file = fs_path(
      path,
      "DESCRIPTION"
    )
  )

  # Changing in ./tests/ if dir present
  set_golem_name_tests(
    old_name = old_name,
    new_name = name,
    pkg = pkg
  )

  # Changing in ./vignettes/ if dir present
  set_golem_name_vignettes(
    old_name = old_name,
    new_name = name,
    pkg = pkg
  )

  if (old_name != name) {
    cli_cli_alert_info(
      sprintf(
        "Please note that the old name %s might still be in some places, for example in the ./docs folder.",
        old_name
      )
    )
    cli_cli_alert_info(
      "You might need to change it manually there.",
    )
  }

  invisible(name)
}

set_golem_name_tests <- function(
  old_name,
  new_name,
  pkg
) {
  pth_dir_tests <- file.path(
    pkg,
    "tests"
  )

  check_dir_tests <- fs_dir_exists(pth_dir_tests)

  if (check_dir_tests) {
    pth_testthat_r <- file.path(pth_dir_tests, "testthat.R")
    old_testthat_r <- readLines(pth_testthat_r)
    new_testthat_r <- gsub(old_name, new_name, old_testthat_r)
    writeLines(new_testthat_r, pth_testthat_r)
  }

  return(invisible(old_name))
}

set_golem_name_vignettes <- function(
  old_name,
  new_name,
  pkg
) {
  pth_dir_vignettes <- file.path(
    pkg,
    "vignettes"
  )

  check_dir_vignettes <- fs_dir_exists(pth_dir_vignettes)

  if (check_dir_vignettes) {
    pth_vignette_old <- file.path(
      pth_dir_vignettes,
      paste0(old_name, ".Rmd")
    )
    old_vignette_r <- readLines(pth_vignette_old)
    new_vignette_r <- gsub(old_name, new_name, old_vignette_r)

    pth_vignette_new <- file.path(
      pth_dir_vignettes,
      paste0(new_name, ".Rmd")
    )
    writeLines(new_vignette_r, pth_vignette_new)
    file.remove(pth_vignette_old)
  }

  return(invisible(old_name))
}

#' @export
#' @rdname golem_opts
set_golem_version <- function(
  version = golem::pkg_version(),
  pkg = golem::pkg_path(),
  talkative = TRUE
) {
  pkg <- fs_path_abs(pkg)

  # Changing in YAML
  amend_golem_config(
    key = "golem_version",
    value = as.character(version),
    config = "default",
    pkg = pkg,
    talkative = talkative
  )

  desc <- desc_description(
    file = fs_path(
      pkg,
      "DESCRIPTION"
    )
  )
  desc$set_version(
    version = version
  )
  desc$write(
    file = "DESCRIPTION"
  )

  invisible(version)
}
