test_that("set_golem_options works", {

  run_quietly_in_a_dummy_golem({
    testthat::with_mocked_bindings(
      usethis_proj_set = function(...) {
        return()
      },
      {
        res <- set_golem_options(
          golem_name = "dummygolem",
          golem_version = "0.0.0.912",
          golem_wd = ".",
          app_prod = FALSE,
          talkative = FALSE,
          config_file = get_current_config(".")
        )
        expect_equal(
          get_golem_name(
            pkg = "."
          ),
          "dummygolem"
        )
        expect_equal(
          get_golem_version(
            pkg = "."
          ),
          "0.0.0.912"
        )
      }
    )
  })
})
