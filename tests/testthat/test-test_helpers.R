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

test_that("test expect_shinytag", {
  testthat::with_mocked_bindings(
    testthat_expect_snapshot = function(...) {
      return(TRUE)
    },
    {
      expect_message(
        expect_html_equal(
          shiny::tagList(),
          html = "test"
        )
      )
      expect_true(
        expect_html_equal(
          shiny::tagList()
        )
      )
    }
  )
})
