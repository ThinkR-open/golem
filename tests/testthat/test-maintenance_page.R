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
    # 2. Test in real life
    res <- perform_inside_a_new_golem(function() {
      pkgload::load_all(".")
      Sys.setenv("GOLEM_MAINTENANCE_ACTIVE" = FALSE)
      app_options_no_maintenance <- run_app()
      Sys.setenv("GOLEM_MAINTENANCE_ACTIVE" = TRUE)
      app_options_maintenance <- run_app()
      return(
        list(
          app_options_no_maintenance = app_options_no_maintenance,
          app_options_maintenance = app_options_maintenance
        )
      )
    })
    expect_false(
      isTRUE(
        all.equal(
          res$app_options_maintenance,
          res$app_options_no_maintenance
        )
      )
    )
  }
)