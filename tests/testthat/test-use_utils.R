test_that("use_utils_ui works", {
  run_quietly_in_a_dummy_golem({
    use_utils_ui(".")
    expect_exists(
      file.path(
        ".",
        "R/golem_utils_ui.R"
      )
    )
    remove_file(
      file.path(
        ".",
        "R/golem_utils_ui.R"
      )
    )

    use_utils_ui(
      ".",
      with_test = TRUE
    )
    # Testint that the function is
    # indempotent by running it twice
    use_utils_ui(
      ".",
      with_test = TRUE
    )

    expect_exists(
      file.path(
        ".",
        "R/golem_utils_ui.R"
      )
    )
    expect_exists(
      file.path(
        ".",
        "tests/testthat/test-golem_utils_ui.R"
      )
    )

    # We test that we can still add the tests even if the utils ui
    # is already there
    remove_file(
      file.path(
        ".",
        "R/golem_utils_ui.R"
      )
    )
    use_utils_ui(
      ".",
      with_test = TRUE
    )

    expect_exists(
      file.path(
        ".",
        "R/golem_utils_ui.R"
      )
    )
    expect_exists(
      file.path(
        ".",
        "tests/testthat/test-golem_utils_ui.R"
      )
    )
  })
})

test_that("use_utils_server works", {
  run_quietly_in_a_dummy_golem({
    use_utils_server(".")
    expect_exists(
      file.path(
        ".",
        "R/golem_utils_server.R"
      )
    )
    remove_file(
      file.path(
        ".",
        "R/golem_utils_server.R"
      )
    )
    use_utils_server(
      ".",
      with_test = TRUE
    )
    # Testing the fun is indempotent
    use_utils_server(
      ".",
      with_test = TRUE
    )

    expect_exists(
      file.path(
        ".",
        "R/golem_utils_server.R"
      )
    )
    expect_exists(
      file.path(
        ".",
        "tests/testthat/test-golem_utils_server.R"
      )
    )
    remove_file(
      file.path(
        ".",
        "R/golem_utils_server.R"
      )
    )
    use_utils_server(
      ".",
      with_test = TRUE
    )
    expect_exists(
      file.path(
        ".",
        "R/golem_utils_server.R"
      )
    )
    expect_exists(
      file.path(
        ".",
        "tests/testthat/test-golem_utils_server.R"
      )
    )
  })
})
