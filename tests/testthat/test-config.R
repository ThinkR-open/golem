test_that("guess_where_config works", {
  # Default behavior, default structure
  run_quietly_in_a_dummy_golem({
    config <- guess_where_config(
      path = "."
    )
    expect_exists(
      config
    )
  })
  # Default behavior, default structure
  run_quietly_in_a_dummy_golem({
    unlink("./inst/golem-config.yml")
    expect_error({
      guess_where_config(
        path = "."
      )
    })
  })

  # Using the envvar, case one with a file that exists
  run_quietly_in_a_dummy_golem({
    fs_file_copy(
      "./inst/golem-config.yml",
      "./inst/golem-config2.yml"
    )
    withr::with_envvar(
      c("GOLEM_CONFIG_PATH" = "./inst/golem-config2.yml"),
      {
        config <- guess_where_config(
          path = "."
        )
        expect_exists(
          config
        )
      }
    )
  })

  # Using the envvar, case one with a file that exists
  run_quietly_in_a_dummy_golem({
    withr::with_envvar(
      c("GOLEM_CONFIG_PATH" = "./inst/golem-config2.yml"),
      {
        expect_error(
          guess_where_config(
            path = "."
          )
        )
      }
    )
  })
})

test_that("get_current_config works", {
  run_quietly_in_a_dummy_golem({
    # We don't need to retest guess_where_config
    testthat::with_mocked_bindings(
      fs_file_exists = function(...) {
        return(FALSE)
      },
      {
        unlink("./inst/golem-config.yml")
        expect_error(get_current_config())
      }
    )
  })
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
    expect_warning({
      change_app_config_name(
        "new_name",
        ".",
        "here"
      )
    })
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
