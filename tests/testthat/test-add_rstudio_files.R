test_that("add_rstudio_files", {
    for (fun in list(
      add_positconnect_file,
      add_shinyappsio_file,
      add_shinyserver_file
    )) {
      dummy_golem <- create_dummy_golem()
      withr::with_options(
        c("usethis.quiet" = TRUE),
        {
          withr::with_dir(
            dummy_golem,
            {
              fun(
                pkg = dummy_golem,
                open = FALSE
              )
            }
          )
        }
      )
      expect_exists(
        file.path(
          dummy_golem,
          "app.R"
        )
      )
      unlink(
        dummy_golem,
        TRUE,
        TRUE
      )
    }
})
