test_that(
  "maintenance page works directly and via with_golem_options()",
  {
    # 1. Test the maintenance feature directly
    html <- maintenance_page()
    expect_true(
      inherits(
        html,
        c("html_document", "shiny.tag.list", "list")
      )
    )
    withr::with_envvar(
      c("GOLEM_MAINTENANCE_ACTIVE" = TRUE),
      {
        app_options_maintenance <- with_golem_options(
          app = shiny::shinyApp(
            ui = list(),
            server = function(input, output, session) {
              shiny::htmlOutput("test")
            }
          ),
          golem_opts = list()
        )
      }
    )
    withr::with_envvar(
      c("GOLEM_MAINTENANCE_ACTIVE" = FALSE),
      {
        app_options_no_maintenance <- with_golem_options(
          app = shiny::shinyApp(
            ui = list(),
            server = function(input, output, session) {
              shiny::htmlOutput("test")
            }
          ),
          golem_opts = list()
        )
      }
    )

    expect_false(
      isTRUE(
        all.equal(
          app_options_maintenance,
          app_options_no_maintenance
        )
      )
    )
  }
)
