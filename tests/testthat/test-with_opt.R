test_that(
  "maintenance page works directly and via with_golem_options()",
  {
    path_dummy_golem <- tempfile(pattern = "dummygolem")
    create_golem(
      path = path_dummy_golem,
      open = FALSE
    )
    with_dir(
      path_dummy_golem,
      {
        # 0. Make dummy golem work as pkg temporarily i.e. run_app() is known
        devtools::load_all()
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
  }
)
test_that(
  "with_golem_options() disables 'print'-flag on Posit for SHINY_PORT",
  {
    path_dummy_golem <- tempfile(pattern = "dummygolem")
    create_golem(
      path = path_dummy_golem,
      open = FALSE
    )
    with_dir(
      path_dummy_golem,
      {
        # 0. Make dummy golem work as pkg temporarily i.e. run_app() is known
        devtools::load_all()
        # I. Test disabling the 'print'-flag on Posit for SHINY_PORT set
        # I.A save output with "print = FALSE" as the testing value
        app_print_false <- run_app()
        # I.B generate a run_app.R file with 'print = TRUE'
        run_app_with_print_FALSE <- readLines("R/run_app.R")
        last_lines <- run_app_with_print_FALSE[26:28]
        last_lines[1] <- "    golem_opts = list(...),"
        run_app_with_print_TRUE <- c(
          run_app_with_print_FALSE[-c(26:28)],
          last_lines[1],
          "    print = TRUE,",
          last_lines[2:3]
        )
        writeLines(run_app_with_print_TRUE, "R/run_app.R")
        # I.B source a new definition for run_app()
        source("R/run_app.R")
        # I.B check that generating app with "SHINY_PORT" sets 'print = FALSE'
        Sys.setenv("SHINY_PORT" = "123")
        # the following code would run "run_app()" with print=TRUE but the
        # environment variable "SHINY_PORT" is set. So the app should run with
        # 'print=FALSE' which we check now:
        app_with_port <- run_app()
        expect_true(
          isTRUE(
            all.equal(
              app_print_false,
              app_with_port
            )
          )
        )
        # II. check that 'print=TRUE' works
        # II.B override print.shiny.appobj inside the shiny pkg-namespace so
        # print(app) inside with_golem_options() can be properly tested
        print_s3_shiny_backup <- getFromNamespace("print.shiny.appobj", "shiny")
        # change print.shiny.appobj method for testing purposes
        print_s3_shiny_tmp_test <- function(app) {
          print("Hello, golem!")
        }
        assignInNamespace(
          "print.shiny.appobj",
          print_s3_shiny_tmp_test,
          ns = "shiny"
        )
        # II.C generate an app with 'print = TRUE' by unsetting the port and
        # using the above updated run_app()
        Sys.setenv("SHINY_PORT" = "")
        # check that print(app) i.e. 'print' is indeed TRUE
        expect_output(
          run_app(),
          "Hello, golem!"
        )
        # Assign back the correct print-method to the shiny pkg-namespace
        assignInNamespace(
          "print.shiny.appobj",
          print_s3_shiny_backup,
          ns = "shiny"
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
        # II. reset global variable and check that this reset is successful
        assignInNamespace(".globals", tmp_globals_backup, ns = "shiny")
        expect_null(shiny::getShinyOption("golem_options"))
        expect_null(get_golem_options())
      }
    )
  }
)
