test_that("maintenance page works directly and via with_golem_options()", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )
  with_dir(
    path_dummy_golem,
    {
      # 1. Test the maintenance feature directly
      html <- maintenance_page()
      expect_true(inherits(html, c("html_document", "shiny.tag.list", "list")))

      # 2. Test the maintenance feature with setting/unsetting the option
      Sys.setenv("GOLEM_MAINTENANCE_ACTIVE" = FALSE)
      app_options_no_maintenance <- run_app()
      Sys.setenv("GOLEM_MAINTENANCE_ACTIVE" = TRUE)
      app_options_maintenance <- run_app()
      # -> should produce different App objects as options are set differently
      expect_false(
        isTRUE(
          all.equal(
            app_options_maintenance,
            app_options_no_maintenance
          )
        )
      )
      Sys.setenv("GOLEM_MAINTENANCE_ACTIVE" = FALSE)
      app_options_maintenance <- run_app()
      # -> should produce the same App object as options are set equally
      expect_equal(
        app_options_maintenance,
        app_options_no_maintenance
      )
    }
  )
})
test_that("with_golem_options() disables 'print'-flag on Posit platforms", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )
  with_dir(
    path_dummy_golem,
    {
    # generate a run_app file with 'print = TRUE'
    # run_app_with_print_FALSE <- readLines("R/run_app.R")
    # last_lines <- run_app_with_print_FALSE[26:28]
    # last_lines[1] <- "    golem_opts = list(...),"
    # run_app_with_print_TRUE <- c(
    #   run_app_with_print_FALSE[-c(26:28)],
    #   last_lines[1],
    #   "    print = FALSE,", last_lines[2:3])
    # writeLines(run_app_with_print_TRUE, "R/run_app.R")
    # source("R/run_app.R")
    app_print_true <- run_app()
    # generate an app with print = FALSE by setting the port
    Sys.setenv("SHINY_PORT" = "123")
    app_with_port <- run_app()
    expect_true(
      isTRUE(
        all.equal(
          app_print_true,
          app_with_port
        )
      )
    )
    # # generate an app with print = TRUE by unsetting the port
    Sys.setenv("SHINY_PORT" = "")
    app_with_port <- run_app()
    expect_equal(
      app_print_true,
      app_with_port
    )
    }
  )
  }
)
# test_that("with_golem_options() disables 'print'-flag on Posit platforms", {
#   path_dummy_golem <- tempfile(pattern = "dummygolem")
#   create_golem(
#     path = path_dummy_golem,
#     open = FALSE
#   )
#   with_dir(
#     path_dummy_golem,
#     {
#       gol_opt_default <- get_golem_options()
#       gol_opt_set     <- get_golem_options()
#       expect_equal(gol_opt_default, gol_opt_set)
#       options(golem.app.prod = FALSE)
#     }
#   )
#   }
# )
