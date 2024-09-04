test_that("config finding works", {
  run_quietly_in_a_dummy_golem({
    config <- guess_where_config(
      path = "."
    )
    expect_exists(
      config
    )
    config <- try_user_config_location(
      pth = "."
    )
    expect_exists(
      config
    )
    expect_null(
      try_user_config_location(tempdir())
    )

    config <- get_current_config(
      path = "."
    )

    expect_exists(
      config
    )

    unlink(
      "R/app_config.R",
      force = TRUE
    )
    unlink(
      "inst/golem-config.yml",
      force = TRUE
    )
    testthat::with_mocked_bindings(
      guess_where_config = function(...) {
        return(NULL)
      },
      rlang_is_interactive = function(...) {
        return(FALSE)
      },
      {
        expect_error(
          get_current_config()
        )
        expect_false(
          file.exists("R/app_config.R")
        )
        expect_false(
          file.exists("inst/golem-config.yml")
        )
      }
    )
    testthat::with_mocked_bindings(
      guess_where_config = function(...) {
        return(NULL)
      },
      fs_file_exists = function(...) {
        return(FALSE)
      },
      rlang_is_interactive = function(...) {
        return(TRUE)
      },
      ask_golem_creation_upon_config = function(...) {
        return(TRUE)
      },
      {
        config <- get_current_config()
        expect_exists(
          config
        )
      }
    )
  })


  testthat::with_mocked_bindings(
    fs_file_exists = function(...) {
      return(FALSE)
    },
    rlang_is_interactive = function(...) {
      return(TRUE)
    },
    ask_golem_creation_upon_config = function(...) {
      return(FALSE)
    },
    {
      config <- get_current_config()

      expect_null(
        config
      )
    }
  )
})

test_that("ask_golem_creation_upon_config works", {
  testthat::with_mocked_bindings(
    yesno = paste,
    {
      expect_snapshot(
        ask_golem_creation_upon_config(
          "/home/golem"
        )
      )
    }
  )
})

test_that("change_app_config_name works", {
  run_quietly_in_a_dummy_golem({
    change_app_config_name(
      "new_name",
      "."
    )
    expect_true(
      grepl(
        "new_name",
        paste(
          readLines("R/app_config.R"),
          collapse = " "
        )
      )
    )
  })
})
