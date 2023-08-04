test_that("is_existing_module() properly detects modules if they are present", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )
  dummy_module_files <- c("mod_main.R", "mod_left_pane.R", "mod_pouet_pouet.R")
  file.create(file.path(path_dummy_golem, "R", dummy_module_files))

  withr::with_dir(path_dummy_golem, {
    expect_false(is_existing_module("foo"))
    expect_true(is_existing_module("left_pane"))
    expect_true(is_existing_module("main"))
    expect_true(is_existing_module("pouet_pouet"))
    expect_false(is_existing_module("plif_plif"))
  })

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE, TRUE)
})

test_that("is_existing_module() fails outside an R package", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  withr::with_dir(path_dummy_golem, {
    dummy_module_files <- c("main.R", "left_pane.R", "pouet_pouet.R")
    unlink("R/", TRUE, TRUE)
    dir.create("RR/")
    file.create(file.path(path_dummy_golem, "RR", dummy_module_files))
    expect_error(
      is_existing_module("foo"),
      "Cannot be called when not inside a R-package"
    )
    expect_error(
      is_existing_module("left_pane"),
      "Cannot be called when not inside a R-package"
    )
    expect_error(
      is_existing_module("main"),
      "Cannot be called when not inside a R-package"
    )
    expect_error(
      is_existing_module("pouet_pouet"),
      "Cannot be called when not inside a R-package"
    )
    expect_error(
      is_existing_module("plif_plif"),
      "Cannot be called when not inside a R-package"
    )
  })

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE, TRUE)
})

test_that("file creation utils fail non-interactively", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  withr::with_dir(path_dummy_golem, {
    tmp_test_file_path <- file.path(getwd(), "R", "tmp_file.R")
    expect_false(file.exists(tmp_test_file_path))
    expect_error(
      rlang::with_interactive(
        {
          create_if_needed(
            tmp_test_file_path,
            type = "file",
            content = "some text"
          )
        },
        value = FALSE
      ),
      paste0("The tmp_file.R file doesn't exist.")
    )
    expect_false(file.exists(tmp_test_file_path))
  })

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE, TRUE)
})

test_that("file creation utils work interactively with user mimick 'no'", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )

  withr::with_dir(path_dummy_golem, {
    tmp_test_file_path <- file.path(getwd(), "R", "tmp_file.R")
    expect_false(file.exists(tmp_test_file_path))
    mockery::stub(
      where = create_if_needed,
      what = "ask_golem_creation_file",
      how = FALSE
    )
    expect_false(
      rlang::with_interactive(
        {
          create_if_needed(
            tmp_test_file_path,
            type = "file",
            content = "some text"
          )
        },
        value = TRUE
      )
    )
    expect_false(file.exists(tmp_test_file_path))
  })

  # Cleanup
  unlink(path_dummy_golem, TRUE, TRUE, TRUE)
})
