test_that("get_golem_things works", {
  run_quietly_in_a_dummy_golem({
    expect_equal(
      get_golem_things(
        "golem_version",
        golem_wd = "."
      ),
      "0.0.0.9000"
    )

    expect_warning(
      get_golem_things(
        "golem_version",
        golem_wd = ".",
        path = "."
      )
    )

    expect_equal(
      get_golem_wd(
        golem_wd = "."
      ),
      getwd()
    )
    expect_warning(
      get_golem_wd(
        pkg = "."
      )
    )
    expect_equal(
      get_golem_name(
        golem_wd = "."
      ),
      "shinyexample"
    )
    expect_warning(
      get_golem_name(
        pkg = "."
      )
    )
    expect_equal(
      get_golem_version(
        golem_wd = "."
      ),
      "0.0.0.9000"
    )
    expect_warning(
      get_golem_version(
        pkg = "."
      )
    )
    # Testing the fallback fun
    golem_config <- yaml::read_yaml(
      "inst/golem-config.yml",
      eval.expr = TRUE
    )
    golem_config$default$golem_version <- NULL
    yaml::write_yaml(
      golem_config,
      "inst/golem-config.yml"
    )
    expect_equal(
      get_golem_version(
        golem_wd = "."
      ),
      "0.0.0.9000"
    )
  })
})
