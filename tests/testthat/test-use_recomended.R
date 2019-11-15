context("tests use_recomended functions")

test_that("test use_recommended_deps",{
  with_dir(pkg,{
    use_recommended_deps()
    packages <- c('shiny', 'DT', 'attempt', 'glue', 'golem', 'htmltools')
    deps <- desc::desc_get_deps(file = "DESCRIPTION")
    test <- purrr::map_lgl(packages, ~ .x %in% deps$package)
    expect_true(all(test))
  })
})


test_that("test use_recommended_tests",{
  with_dir(pkg,{
    use_recommended_tests()
    expect_true(dir.exists("tests"))
    expect_true(file.exists("tests/testthat/test-golem-recommended.R"))
  })
})
