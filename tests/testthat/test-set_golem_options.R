test_that("set_golem_options works", {
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      testthat::with_mocked_bindings(
        usethis_proj_set = function(...) {
          return()
        },
        {
          withr::with_dir(
            dummy_golem,
            {
              res <- set_golem_options(
                golem_name = "dummygolem",
                golem_version = "0.0.0.912",
                golem_wd = dummy_golem,
                app_prod = FALSE,
                talkative = FALSE,
                config_file = golem::get_current_config(dummy_golem)
              )
            }
          )
        }
      )
      expect_equal(
        get_golem_name(
          pkg = dummy_golem
        ),
        "dummygolem"
      )
      expect_equal(
        get_golem_version(
          pkg = dummy_golem
        ),
        "0.0.0.912"
      )
    }
  )
  unlink(
    dummy_golem,
    recursive = TRUE,
    force = TRUE
  )
})
