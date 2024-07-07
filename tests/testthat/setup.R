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
      CACABOUDIN(
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
  dir.create(
    file.path(
      path_to_golem,
      "dev"
    ),
    recursive = TRUE
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
  dir.create(
    file.path(
      path_to_golem,
      "man"
    ),
    recursive = TRUE
  )
  return(path_to_golem)
}
