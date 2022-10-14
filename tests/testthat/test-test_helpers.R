test_that("test expect_shinytag", {
  with_dir(pkg, {
    withr::with_options(
      c("golem.quiet" =  FALSE),{
        expect_equal(capture_output(expect_shinytag(favicon("jean"))), "")
        expect_error(expect_shinytag("pierre"))
      })
  })
})

test_that("test expect_shinytaglist", {
  with_dir(pkg, {
    withr::with_options(
      c("golem.quiet" =  FALSE),{
        expect_equal(capture_output(expect_shinytaglist(shiny::tagList())), "")
        expect_error(expect_shinytaglist("test"))
    })
  })
})
