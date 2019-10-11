context("tests get_dependencies")

test_that("test get_dependencies",{
  with_dir(pkg,{
    test <- get_dependencies()
    expect_equal(test, c("shiny","golem", "R6"))
    test2 <- capture_output(get_dependencies(dput = TRUE))
    expect_equal(test2,"c(\"shiny\", \"golem\", \"R6\")")
  })
})
