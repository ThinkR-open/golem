test_that("config finding works", {
  run_quietly_in_a_dummy_golem({
    # I. Testing behavior of the helper function - first case:
    # file lives in default path and no envir-variable
    config <- guess_where_config(
      path = "."
    )
    expect_exists(
      config
    )
    # II. Testing behavior of the helper function - second case:
    # file lives in default path, and envir-variable set correctly
    Sys.setenv("GOLEM_CONFIG_PATH" = "./inst/golem-config.yml")
    config <- guess_where_config(
      path = "."
    )
    expect_exists(
      config
    )
    # III. Testing behavior of the helper function - third case:
    # file lives in default path, and envir-variable set incorrectly
    Sys.setenv("GOLEM_CONFIG_PATH" = "./inst/golem-config2.yml")
    testthat::expect_error(
      config <- guess_where_config(
        path = "."
        ),
      regexp = "Unable to locate a config file using the environment variable"
    )
    Sys.setenv("GOLEM_CONFIG_PATH" = "")
    # IV. Testing behavior of the helper function - fourth case:
    # file lives in another path, and hard coded path is wrongly passed
    file.copy(from = "./inst/golem-config.yml",
                to = "./inst/golem-config3.yml")
    file.remove("./inst/golem-config.yml")
    testthat::expect_error(
      config <- guess_where_config(
        path = ".",
        file = "inst/golem-config2.yml"
      ),
      regexp = "Unable to locate a config file from either the 'path' and 'file'"
    )
    # V. Testing behavior of the helper function:
    # file lives in another path, and envir-var or path to file is wrong
    Sys.setenv("GOLEM_CONFIG_PATHHHHH" = "./inst/golem-config2.yml")
    testthat::expect_error(
      config <- guess_where_config(
        path = ".",
        file = "inst/golem-config2.yml"
      ),
      regexp = "Unable to locate a config file from either the 'path' and 'file'"
    )
    file.copy(from = "./inst/golem-config3.yml",
              to = "./inst/golem-config.yml")
    file.remove("./inst/golem-config3.yml")
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
        expect_equal(config, NULL)
      }
    )
    testthat::with_mocked_bindings(
      fs_file_exists = function(...) {
        return(FALSE)
      },
      rlang_is_interactive = function(...) {
        return(FALSE)
      },
      ask_golem_creation_upon_config = function(...) {
        return(FALSE)
      },
      {
        expect_error(get_current_config())
      }
    )
  })


  # testthat::with_mocked_bindings(
  #   fs_file_exists = function(...) {
  #     return(FALSE)
  #   },
  #   rlang_is_interactive = function(...) {
  #     return(TRUE)
  #   },
  #   ask_golem_creation_upon_config = function(...) {
  #     return(FALSE)
  #   },
  #   {
  #     config <- get_current_config()
  #
  #     expect_null(
  #       config
  #     )
  #   }
  # )
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
