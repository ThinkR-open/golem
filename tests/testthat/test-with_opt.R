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
test_that(
  "with_golem_options() disables 'print'-flag on Posit platforms",
  {
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
test_that(
  "get_golem_options() retrieves 'golem_options'",
  {
    path_dummy_golem <- tempfile(pattern = "dummygolem")
    create_golem(
      path = path_dummy_golem,
      open = FALSE
    )
    with_dir(
      path_dummy_golem,
      {
        # 0. Preparation:
        # 0.A backup hidden variable '.global' from the shiny pkg-namespace
        tmp_globals_backup <- getFromNamespace(".globals", "shiny")
        # 0.B make a full clone of this variable (which is an environment)
        tmp_globals_override <- as.environment(
          as.list(
            tmp_globals_backup,
            all.names = TRUE
          )
        )
        # 0.C mimick the existence of "golem_options" inside the clone
        tmp_globals_override$options$golem_options$country_01 <- "france"
        tmp_globals_override$options$golem_options$country_02 <- "germany"
        # I Testing:
        # I.A temporarily override ".globals" with the clone
        assignInNamespace(".globals", tmp_globals_override, ns = "shiny")
        # I.B test that get_golem_options() correctly retrieves "golem_options"
        expect_equal(
          get_golem_options(),
          list(
            country_01 = "france",
            country_02 = "germany"
          )
        )
        expect_equal(
          get_golem_options("country_01"),
          "france"
        )
        expect_equal(
          get_golem_options("country_02"),
          "germany"
        )
        # II. assign global variable back and check that this reset is successful
        assignInNamespace(".globals", tmp_globals_backup, ns = "shiny")
        expect_null(getShinyOption("golem_options"))
        expect_null(get_golem_options())
      }
    )
  }
)
