test_that("config works", {
  with_dir(pkg, {
    # We'll try to be sure that
    # golem_wd: !expr golem::pkg_path()
    # is kept along the way
    expect_equal(
      tail(readLines("inst/golem-config.yml"), 1),
      "  golem_wd: !expr golem::pkg_path()"
    )
    expect_equal(
      get_golem_name(),
      fakename
    )
    expect_equal(
      get_golem_version(),
      "0.0.0.9000"
    )
    expect_equal(
      normalizePath(get_golem_wd(), mustWork = FALSE),
      normalizePath(pkg, mustWork = FALSE)
    )
    amend_golem_config(
      key = "where",
      value = "indev"
    )
    amend_golem_config(
      key = "where",
      value = "inprod",
      config = "production"
    )
    expect_equal(
      tail(readLines("inst/golem-config.yml"), 1),
      "  golem_wd: !expr golem::pkg_path()"
    )
    expect_equal(
      config::get("where", file = "inst/golem-config.yml"),
      "indev"
    )
    expect_equal(
      config::get("where", config = "production", file = "inst/golem-config.yml"),
      "inprod"
    )
    where_conf <- withr::with_envvar(
      c("R_CONFIG_ACTIVE" = "production"),
      {
        config::get("where", file = "inst/golem-config.yml")
      }
    )
    expect_equal(
      where_conf,
      "inprod"
    )
    set_golem_name("plop")
    expect_equal(
      get_golem_name(),
      "plop"
    )
    set_golem_name(fakename)
    set_golem_version("0.0.0.9001")
    expect_equal(
      get_golem_version(),
      "0.0.0.9001"
    )
    set_golem_version("0.0.0.9000")

    set_golem_wd(normalizePath("inst"))
    expect_equal(
      normalizePath(get_golem_wd()),
      normalizePath("inst")
    )
    set_golem_wd(pkg)
    # Be sure that after setting the stuff the wd is still here::here()
    expect_equal(
      tail(readLines("inst/golem-config.yml"), 1),
      "  golem_wd: !expr golem::pkg_path()"
    )
  })
})
test_that("golem-config.yml can be renamed and moved to another location", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  ## The default config path is returned
  expect_equal(
    guess_where_config(),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/golem-config.yml"
    ))
  )
  ## Some renamed config AND under a different path is returned
  ## I. create new dir
  dir.create(
    "inst/config"
  )
  ## II. Move config file under a different name to that dir
  file.copy(
    from = "inst/golem-config.yml",
    to = "inst/config/golem.yml"
  )
  ## III Save content of default config to restore and for final test later
  tmp_app_config_default <- readLines("R/app_config.R")
  # IV.A User alters correct line in app_config.R: different path AND filename!
  tmp_app_config_test_01 <- readLines("R/app_config.R")
  tmp_app_config_test_01[36] <- "  file = app_sys(\"config/golem.yml\")"
  writeLines(tmp_app_config_test_01, "R/app_config.R")
  # Keeping two configs (user and default) is forbidden i.e. we expect an error
  expect_error(guess_where_config())
  ## Remove old config file
  file.remove(
    "inst/golem-config.yml"
  )
  # IV.A The updated config is found
  expect_equal(
    guess_where_config(),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/config/golem.yml"
    ))
  )
  ## IV.B app_config.R has a multi-line statement
  ## -   > e.g. because of grkstyle formatting or long path names
  tmp_app_config_test_02 <- tmp_app_config_default
  tmp_max_lines_config <- length(tmp_app_config_test_02)
  tmp_app_config_test_02[36] <- "  file = app_sys("
  tmp_app_config_test_02 <- c(
    tmp_app_config_test_02[1:36],
    "\"config/golem.yml\"",
    ")",
    tmp_app_config_test_02[37:tmp_max_lines_config]
  )
  writeLines(tmp_app_config_test_02, "R/app_config.R")
  # IV.B The updated config  with multi-line app_sys()-call is read correctly
  expect_equal(
    guess_where_config(),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/config/golem.yml"
    ))
  )
  ## IV.C app_config.R has a malformatted app_sys(...) call
  ##    -> e.g. because of grkstyle formatting or long path names
  tmp_app_config_test_03 <- tmp_app_config_default
  ## malformation = typo: app_syss() instead of app_sys()
  tmp_app_config_test_03[36] <- "  file = app_syss(\"config/golem.yml\")"
  writeLines(tmp_app_config_test_03, "R/app_config.R")
  # IV.C The updated config  with multi-line app_sys()-call is read correctly
  expect_null(guess_where_config())
  # V. And finally if default config-file is missing AND no valid app_config.R
  # V.A test that default sub-function returns path
  tmp_app_config_test_03[36] <- "  file = app_sys(\"config/golem.yml\")"
  writeLines(tmp_app_config_test_03, "R/app_config.R")
  expect_equal(
    try_user_config_location(pkg_path()),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/config/golem.yml"
    ))
  )
  # V.B test that default sub-function fails to return path and gives NULL
  file.remove("R/app_config.R")
  expect_null(try_user_config_location(pkg_path()))

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE)
})

test_that("golem-config.yml can be retrieved for some exotic corner cases", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  # Test exotic case IV.A - for some reason wd is set to subdir "inst/"
  # Change dir to subdir "inst"
  setwd(file.path(getwd(), "inst"))
  # Test that the default config path is returned
  expect_equal(
    guess_where_config(),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/golem-config.yml"
    ))
  )

  # Test exotic case IV.B - for some reason wd is set to subdir "inst/"
  # Change dir to golem-pkg toplevel
  setwd(path_dummy_golem)
  # The default config path is returned though arguments are non-sense
  expect_equal(
    guess_where_config("hi", "there"),
    fs_path_abs(file.path(
      path_dummy_golem,
      "inst/golem-config.yml"
    ))
  )
  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE)
})

test_that("get_current_config() fails non-interactively with proper error", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  pth_golem_ymlconf <- file.path(path_dummy_golem, "inst/golem-config.yml")

  # Force the if-clause evaluation of get_current_config() for a NULL path
  file.remove(pth_golem_ymlconf)
  # Test that error is returned in NON-INTERACTIVE mode
  expect_error(
    rlang::with_interactive(
      {
        get_current_config("some/nonesense/path/to/test")
      },
      value = FALSE
    ),
    "The golem-config.yml file doesn't exist"
  )
  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE)
})

test_that("get_current_config() interactively recreates files upon user wish", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  pth_golem_ymlconf <- file.path(path_dummy_golem, "inst/golem-config.yml")
  pth_golem_appconf <- file.path(path_dummy_golem, "R/app_config.R")

  # Test that golem-specific files are copied in INTERACTIVE mode
  # I. remove files before they are copied
  # 1. golem-config-yaml; remove and check if missing
  expect_true(file.exists(pth_golem_ymlconf))
  file.remove(pth_golem_ymlconf)
  expect_false(file.exists(pth_golem_ymlconf))
  # 2. R/app_config.R; remove and check if missing
  expect_true(file.exists(pth_golem_appconf))
  file.remove(pth_golem_appconf)
  expect_false(file.exists(pth_golem_appconf))
  # II. check that copying works: interactive is bypassed as-if user says "yes"
  mockery::stub(
    where = get_current_config,
    what = "ask_golem_creation_upon_config",
    how = TRUE
  )
  expect_equal(
    rlang::with_interactive({
      get_current_config(path_dummy_golem)
    },
    value = TRUE
    ),
    fs_path_abs(pth_golem_ymlconf)
  )
  expect_true(file.exists(pth_golem_ymlconf))
  expect_true(file.exists(pth_golem_appconf))

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE)
})

test_that("get_current_config() interactively returns NULL upon user wish", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  pth_golem_ymlconf <- file.path(path_dummy_golem, "inst/golem-config.yml")
  pth_golem_appconf <- file.path(path_dummy_golem, "R/app_config.R")

  # Test that golem-specific files are copied in INTERACTIVE mode
  # I. remove files before they are copied
  # 1. golem-config-yaml; remove and check if missing
  expect_true(file.exists(pth_golem_ymlconf))
  file.remove(pth_golem_ymlconf)
  expect_false(file.exists(pth_golem_ymlconf))
  # 2. R/app_config.R; remove and check if missing
  expect_true(file.exists(pth_golem_appconf))
  file.remove(pth_golem_appconf)
  expect_false(file.exists(pth_golem_appconf))
  # II. check that copying works: interactive is bypassed as-if user says "no"
  mockery::stub(
    where = get_current_config,
    what = "ask_golem_creation_upon_config",
    how = FALSE
  )
  expect_null(
    rlang::with_interactive({
      get_current_config(path_dummy_golem)
    },
    value = TRUE
    )
  )
  expect_false(file.exists(pth_golem_ymlconf))
  expect_false(file.exists(pth_golem_appconf))

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE)
})

test_that("ask_golem_creation_upon_config() fails in non-interactive mode", {
  expect_error(ask_golem_creation_upon_config("test/path"))
})
