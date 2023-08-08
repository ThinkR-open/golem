path_dummy_golem <- tempfile(pattern = "dummygolem")
create_golem(
  path = path_dummy_golem,
  open = FALSE
)
test_that("run_dev() works for different files and fails if missing", {
  with_dir(
    path_dummy_golem,
    {
      # Adjust file for testing run_dev() with default file="dev/run_dev.R"
      run_dev_update <- readLines("dev/run_dev.R")
      # suppress other behavior of run_dev that is not meant for testing
      run_dev_update[2] <- "# options(golem.app.prod = FALSE)"
      run_dev_update[6] <- "# options(shiny.port = httpuv::randomPort())"
      run_dev_update[8] <- "# golem::detach_all_attached()"
      run_dev_update[12] <- "# golem::document_and_reload()"
      run_dev_update[15] <- "print('DEFAULT run_dev')"
      # write new run_dev.R file for testing
      run_dev_update <- writeLines(run_dev_update, "dev/run_dev.R")
      # Make a copy of run_dev and move it elsewhere (but inside golem)
      file.copy(
        from = "dev/run_dev.R",
        to = file.path(get_golem_wd(), "run_dev2.R")
      )
      # Adjust copy for testing run_dev() with user supplied file="run_dev2.R"
      run_dev_update <- readLines("run_dev2.R")
      run_dev_update[15] <- "print('NEW run_dev2')"
      run_dev_update <- writeLines(run_dev_update, "run_dev2.R")
      # The default run_dev works
      expect_output(
        run_dev(),
        regexp = "DEFAULT run_dev"
      )
      # The new run_dev2 works too
      expect_output(
        run_dev(file = "run_dev2.R"),
        regexp = "NEW run_dev2"
      )
      # A wrong path supplied to 'file' fails  with informative error
      expect_error(
        run_dev(file = "run_dev3.R"),
        regexp = "Unable to locate the run_dev-file passed via the 'file' argument."
      )
      unlink(path_dummy_golem, recursive = TRUE)
    }
  )
})
