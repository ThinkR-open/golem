test_that("test use_recommended_deps", {
  testthat::skip_on_cran()
  with_dir(pkg, {
    packages <- c("shiny", "DT", "attempt", "glue", "golem", "htmltools")
    to_add <- c()
    for (i in packages) {
      if (requireNamespace(i)) {
        to_add <- c(to_add, i)
      }
    }
    expect_warning(
      use_recommended_deps(recommended = to_add)
    )
    deps <- desc::desc_get_deps(file = "DESCRIPTION")
    expect_true(
      all(to_add %in% deps$package)
    )
  })
})


test_that("test use_recommended_tests", {
  with_dir(pkg, {
    use_recommended_tests(spellcheck = FALSE)
    expect_true(dir.exists("tests"))
    expect_exists("tests/testthat/test-golem-recommended.R")
  })
})
