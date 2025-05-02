test_that(
  "with_golem_options() returns the maintenance page",
  {
    res <- withr::with_envvar(
      c("GOLEM_MAINTENANCE_ACTIVE" = "TRUE"),
      {
        with_golem_options(
          shiny::shinyApp(
            ui = list(),
            server = function(input, output, session) {}
          ),
          golem_opts = list()
        )
      }
    )
    ui <- res$httpHandler(
      list(
        "REQUEST_METHOD" = "GET",
        "PATH_INFO" = "/"
      )
    )
    expect_equal(
      as.character(
        ui$content
      ),
      as.character(
        maintenance_page()
      )
    )
  }
)

test_that(
  "We can explicitely print the golem app",
  {
    res <- testthat::with_mocked_bindings(
      .package = "base",
      print = function(...) {
        return("Kilian Jornet")
      },
      code = {
        with_golem_options(
          print = TRUE,
          shiny::shinyApp(
            ui = list(),
            server = function(input, output, session) {}
          ),
          golem_opts = list()
        )
      }
    )
    expect_equal(
      res,
      "Kilian Jornet"
    )
  }
)

test_that(
  "with_golem_options() disables 'print'-flag on Posit for SHINY_PORT",
  {
    # This tests is here so that we ensure that
    # even if the `print` is set to TRUE in with_golem_options,
    # it is turned off if we detect that we are on
    # a Posit Connect machine, using the
    # SHINY_PORT env var

    res <- withr::with_envvar(
      c("SHINY_PORT" = "1234"),
      {
        with_golem_options(
          print = TRUE,
          shiny::shinyApp(
            ui = list(),
            server = function(input, output, session) {}
          ),
          golem_opts = list()
        )
      }
    )

    this_shouldnt_be_printed_but_be_a_shiny_app_obj <- {
      force(res)
    }
    expect_true(
      inherits(
        this_shouldnt_be_printed_but_be_a_shiny_app_obj,
        "shiny.appobj"
      )
    )
  }
)



test_that(
  "get_golem_options() retrieves 'golem_options'",
  {
    # 0. Preparation:
    # 0.A backup hidden variable '.global' from the shiny pkg-namespace
    tmp_globals_backup <- getFromNamespace(
      ".globals",
      "shiny"
    )
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
    assignInNamespace(
      ".globals",
      tmp_globals_override,
      ns = "shiny"
    )
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
    assignInNamespace(
      ".globals",
      tmp_globals_backup,
      ns = "shiny"
    )
    expect_null(
      getShinyOption("golem_options")
    )
    expect_null(
      get_golem_options()
    )
  }
)
