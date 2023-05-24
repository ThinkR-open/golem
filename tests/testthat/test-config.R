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
test_that("golem-config.yml can be moved to another location", {

  path_dummy_golem <- tempfile(pattern = "dummygolem")

  golem::create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  old_wd <- setwd(path_dummy_golem)
  on.exit(setwd(old_wd))

  # The good config path is returned
  expect_equal(
    golem:::guess_where_config(),
    golem:::fs_path_abs(file.path(
      path_dummy_golem,
      "inst/golem-config.yml"
    ))
  )
  # document_and_reload does not throw an error
  expect_error(
    document_and_reload(),
    regexp = NA
  )
  expect_equal(
    get_golem_name(),
    basename(path_dummy_golem)
  )
  expect_equal(
    get_golem_wd(),
    path_dummy_golem
  )

  ## Move config file
  dir.create(
    "inst/config"
  )
  file.copy(
    from = "inst/golem-config.yml",
    to = "inst/config/golem.yml"
  )
  file.remove(
    "inst/golem-config.yml"
  )
  # User adjusts the correct line in app_config.R:
  tmp_app_config_r <- readLines("R/app_config.R")
  tmp_app_config_r[36] <- "  file = app_sys(\"config/golem.yml\")"
  writeLines(tmp_app_config_r, "R/app_config.R")

  # The good config path is returned
  expect_equal(
    golem:::guess_where_config(),
    golem:::fs_path_abs(file.path(
      path_dummy_golem,
      "inst/config/golem.yml"
    ))
  )
  # document_and_reload does not throw an error
  expect_error(
    document_and_reload(),
    regexp = NA
  )
  expect_equal(
    get_golem_name(),
    basename(path_dummy_golem)
  )
})
