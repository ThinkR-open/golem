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

test_that(
  "expect_running",{
    testthat::with_mocked_bindings(
      rlang_is_interactive = function() {
        return(TRUE)
      },
      processx_process = function(...) {
        list(
          is_alive = function() {
            return(TRUE)
          },
          kill = function() {
            return(TRUE)
          }
        )
      },
      {
        expect_true(
          expect_running(
            sleep = 0
          )
        )
      }
    )
  }
)

test_that(
  "processx_process is correct", {
    expect_equal(
      processx_process("R"),
      processx::process$new("R")
    )
  }
)
