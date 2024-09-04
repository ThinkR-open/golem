test_that("get_golem_things works", {
  run_quietly_in_a_dummy_golem({
    expect_equal(
      get_golem_things(
        "golem_version",
        path = "."
      ),
      "0.0.0.9000"
    )
    expect_equal(
      get_golem_wd(
        pkg = "."
      ),
      getwd()
    )
    expect_equal(
      get_golem_name(
        pkg = "."
      ),
      "shinyexample"
    )
    expect_equal(
      get_golem_version(
        pkg = "."
      ),
      "0.0.0.9000"
    )
  })
})
