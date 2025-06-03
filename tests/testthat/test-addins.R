test_that("go_to works", {
  dummy_golem <- create_dummy_golem()

  testthat::with_mocked_bindings(
    rstudioapi_hasFun = function(x) {
      return(TRUE)
    },
    rstudioapi_navigateToFile = function(x) {
      file.exists(
        x
      )
    },
    code = {
      these_all_should_be_true <- c(
        go_to_start(
          golem_wd = dummy_golem
        ),
        go_to_dev(
          golem_wd = dummy_golem
        ),
        go_to_deploy(
          golem_wd = dummy_golem
        ),
        go_to_run_dev(
          golem_wd = dummy_golem
        ),
        go_to_app_ui(
          golem_wd = dummy_golem
        ),
        go_to_app_server(
          golem_wd = dummy_golem
        ),
        go_to_run_app(
          golem_wd = dummy_golem
        )
      )
    }
  )
  expect_true(
    unique(
      these_all_should_be_true
    )
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
