test_that("test expect_shinytag", {
  expect_equal(
    capture_output(
      expect_shinytag(favicon("jean"))
    ),
    ""
  )
  expect_error(
    expect_shinytag("pierre")
  )
})

test_that("test expect_shinytaglist", {
  expect_equal(
    capture_output(
      expect_shinytaglist(
        shiny::tagList()
      )
    ),
    ""
  )
  expect_error(
    expect_shinytaglist("test")
  )
})
