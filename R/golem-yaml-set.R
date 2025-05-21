#' @export
#' @rdname golem_opts
set_golem_wd <- function(
  new_golem_wd = golem::pkg_path(),
  current_golem_wd = golem::pkg_path(),
  talkative = TRUE,
  golem_wd,
  pkg
) {
  signal_arg_is_deprecated(
    golem_wd,
    fun = as.character(sys.call()[[1]]),
    "golem_wd",
    "new_golem_wd"
  )
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]]),
    "pkg",
    "old_golem_wd"
  )
  if (
    new_golem_wd == "golem::pkg_path()" |
      normalizePath(new_golem_wd) == normalizePath(golem::pkg_path())
  ) {
    golem_yaml_path <- "golem::pkg_path()"
    attr(golem_yaml_path, "tag") <- "!expr"
  } else {
    golem_yaml_path <- fs_path_abs(new_golem_wd)
  }

  amend_golem_config(
    key = "golem_wd",
    value = golem_yaml_path,
    config = "dev",
    pkg = current_golem_wd,
    talkative = talkative
  )

  invisible(golem_yaml_path)
}

#' @export
#' @rdname golem_opts
set_golem_name <- function(
  name = golem::pkg_name(),
  golem_wd = golem::pkg_path(),
  talkative = TRUE,
  old_name = golem::pkg_name(),
  pkg
) {
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]])
  )
  # Changing in YAML
  amend_golem_config(
    key = "golem_name",
    value = name,
    config = "default",
    pkg = fs_path_abs(golem_wd),
    talkative = talkative
  )

  # Changing in app_config.R
  change_app_config_name(
    name = name,
    golem_wd = golem_wd
  )

  # Changing in DESCRIPTION
  desc <- desc_description(
    file = fs_path(
      golem_wd,
      "DESCRIPTION"
    )
  )
  desc$set(
    Package = name
  )
  desc$write(
    file = fs_path(
      golem_wd,
      "DESCRIPTION"
    )
  )

  # Changing in ./tests/ if dir present
  set_golem_name_tests(
    old_name = old_name,
    new_name = name,
    golem_wd = golem_wd
  )

  # Changing in ./vignettes/ if dir present
  set_golem_name_vignettes(
    old_name = old_name,
    new_name = name,
    golem_wd = golem_wd
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
  golem_wd
) {
  pth_dir_tests <- file.path(
    golem_wd,
    "tests"
  )

  check_dir_tests <- fs_dir_exists(pth_dir_tests)

  # This will update the library call in the testthat folder
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
  golem_wd
) {
  pth_dir_vignettes <- file.path(
    golem_wd,
    "vignettes"
  )

  check_dir_vignettes <- fs_dir_exists(pth_dir_vignettes)

  # We'll read the vignette and change the value of
  # the name if ever it is found in a vignette
  if (check_dir_vignettes) {
    list_of_vignettes_to_gsub <- list.files(
      pth_dir_vignettes,
      full.names = TRUE,
      pattern = ".Rmd"
    )
    if (length(list_of_vignettes_to_gsub) > 0) {
      for (one_vignette in list_of_vignettes_to_gsub) {
        old_vignette_r <- readLines(one_vignette)
        new_vignette_r <- gsub(old_name, new_name, old_vignette_r)
        writeLines(new_vignette_r, one_vignette)
      }
    }
  }

  return(invisible(old_name))
}

#' @export
#' @rdname golem_opts
set_golem_version <- function(
  version = golem::pkg_version(),
  golem_wd = golem::pkg_path(),
  talkative = TRUE,
  pkg
) {
  signal_arg_is_deprecated(
    pkg,
    fun = as.character(sys.call()[[1]]),
    "pkg"
  )
  golem_wd <- fs_path_abs(golem_wd)

  # Changing in YAML
  amend_golem_config(
    key = "golem_version",
    value = as.character(version),
    config = "default",
    pkg = golem_wd,
    talkative = talkative
  )

  desc <- desc_description(
    file = fs_path(
      golem_wd,
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
