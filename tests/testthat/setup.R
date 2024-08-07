am_i_in_covrmode <- function() {
  Sys.getenv("R_COVR") != ""
}

am_i_in_testfile <- function() {
  Sys.getenv("TESTTHAT_PKG") == ""
}

am_i_in_devtools_test <- function() {
  Sys.getenv("TESTTHAT_IS_CHECKING") == ""
}

where_am_i_testing_from <- function() {
  # covr::package_coverage =>
  # package is installed in a temp lib
  # and launched via library()
  if (am_i_in_covrmode()) {
    return("covr::package_coverage")
  }
  # testthat::test_file =>
  # current package is pkgload::load_all()
  # and the libPath is the  same as the  current
  # session
  if (am_i_in_testfile()) {
    return("testthat::test_file")
  }
  # devtools::test =>
  # current package is pkgload::load_all()
  # and the libPath is the  same as the  current
  # session but you have access to the package
  # name via Sys.getenv("TESTTHAT_PKG")
  if (am_i_in_devtools_test()) {
    return("devtools::test")
  }

  # rcmdcheck::rcmdcheck or devtools::check()
  # current package is installed in a temp lib
  # and is library()
  return("rcmdcheck::rcmdcheck")
}

perform_inside_a_new_golem <- function(fun) {
  im_testing_from <- where_am_i_testing_from()

  a_callr_session <- callr::r_session$new()

  if (im_testing_from %in% c(
    "covr::package_coverage",
    "rcmdcheck::rcmdcheck"
  )) {
    load_function <- function() {
      library(Sys.getenv("TESTTHAT_PKG"), character.only = TRUE)
    }
  } else {
    load_function <- pkgload::load_all
  }

  res <- a_callr_session$run(
    function(f) {
      f()
    },
    args = list(
      f = load_function
    )
  )

  pkg_path <- a_callr_session$run(function() {
    ## fake package
    pkg_reload <- file.path(
      tempdir(),
      paste0(
        sample(letters, 10, TRUE),
        collapse = ""
      )
    )
    if (!dir.exists(pkg_reload)) {
      golem::create_golem(
        pkg_reload,
        open = FALSE
      )
    }
    setwd(pkg_reload)
    return(pkg_reload)
  })

  res <- a_callr_session$run(fun)

  a_callr_session$finalize()

  return(res)
}


### Funs
remove_file <- function(path) {
  if (file.exists(path)) unlink(path, force = TRUE)
}

expect_exists <- function(fls) {
  act <- list(
    val = fls,
    lab = fls
  )

  act$val <- file.exists(fls)
  expect(
    isTRUE(act$val),
    sprintf("File %s doesn't exist.", fls)
  )

  invisible(act$val)
}

create_dummy_golem <- function() {
  # we're using this fun to do a
  # minimal reprex of a golem
  # without having to go through the
  # create_golem() function
  path_to_golem <- file.path(
    tempdir(),
    "dummygolem"
  )
  if (dir.exists(path_to_golem)) {
    unlink(path_to_golem, recursive = TRUE, force = TRUE)
  }
  dir.create(
    path_to_golem,
    recursive = TRUE
  )
  file.copy(
    golem_sys(
      "shinyexample/DESCRIPTION"
    ),
    file.path(
      path_to_golem,
      "DESCRIPTION"
    )
  )
  dir.create(
    file.path(
      path_to_golem,
      "R"
    ),
    recursive = TRUE
  )
  dir.create(
    file.path(
      path_to_golem,
      "tests/testthat"
    ),
    recursive = TRUE
  )
  file.create(
    file.path(
      path_to_golem,
      "tests/testthat.R"
    )
  )
  write(
    "# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(shinyexample)

test_check(\"shinyexample\")",
    file.path(
      path_to_golem,
      "tests/testthat.R"
    )
  )
  dir.create(
    file.path(
      path_to_golem,
      "dev"
    ),
    recursive = TRUE
  )
  file.copy(
    golem_sys(
      "shinyexample/dev/01_start.R"
    ),
    file.path(
      path_to_golem,
      "dev/01_start.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/dev/02_dev.R"
    ),
    file.path(
      path_to_golem,
      "dev/02_dev.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/dev/03_deploy.R"
    ),
    file.path(
      path_to_golem,
      "dev/03_deploy.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/dev/run_dev.R"
    ),
    file.path(
      path_to_golem,
      "dev/run_dev.R"
    )
  )
  dir.create(
    file.path(
      path_to_golem,
      "inst/app/www/"
    ),
    recursive = TRUE
  )
  file.create(
    file.path(
      path_to_golem,
      "inst/app/www/favicon.ico"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/inst/golem-config.yml"
    ),
    file.path(
      path_to_golem,
      "inst/golem-config.yml"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/R/app_config.R"
    ),
    file.path(
      path_to_golem,
      "R/app_config.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/R/app_ui.R"
    ),
    file.path(
      path_to_golem,
      "R/app_ui.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/R/app_server.R"
    ),
    file.path(
      path_to_golem,
      "R/app_server.R"
    )
  )
  file.copy(
    golem_sys(
      "shinyexample/R/run_app.R"
    ),
    file.path(
      path_to_golem,
      "R/run_app.R"
    )
  )
  dir.create(
    file.path(
      path_to_golem,
      "man"
    ),
    recursive = TRUE
  )
  dir.create(
    file.path(
      path_to_golem,
      "vignettes"
    )
  )
  file.create(
    file.path(
      path_to_golem,
      "vignettes/shinyexample.Rmd"
    )
  )
  write(
    "library(shinyexample)",
    file.path(
      path_to_golem,
      "vignettes/shinyexample.Rmd"
    )
  )
  return(path_to_golem)
}

run_quietly_in_a_dummy_golem <- function(expr) {

  on.exit(
    {
      unlink(
        dummy_golem,
        TRUE,
        TRUE
      )
    },
    add = TRUE
  )
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      withr::with_dir(
        dummy_golem,
        expr
      )
    }
  )
}
