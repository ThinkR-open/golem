test_that("test use_utils_ui", {
  with_dir(pkg, {
    remove_file("R/golem_utils_ui.R")
    use_utils_ui()
    expect_exists("R/golem_utils_ui.R")
    remove_file("R/golem_utils_ui.R")

    remove_file("R/golem_utils_ui.R")
    use_utils_ui(with_test = TRUE)
    expect_exists("R/golem_utils_ui.R")
    expect_exists("tests/testthat/test-golem_utils_ui.R")
  })
})

test_that("test use_utils_server", {
  with_dir(pkg, {
    remove_file("R/golem_utils_server.R")
    use_utils_server()
    expect_exists("R/golem_utils_server.R")
    remove_file("R/golem_utils_server.R")

    remove_file("R/golem_utils_server.R")
    use_utils_server(with_test = TRUE)
    expect_exists("R/golem_utils_server.R")
    expect_exists("tests/testthat/test-golem_utils_server.R")
  })
})
