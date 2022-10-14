test_that("test app_dev", {
  with_options(
    c(
      golem.app.prod = TRUE
    ),
    {
      expect_false(app_dev())
      expect_true(app_prod())
    }
  )
  with_options(
    c(
      golem.app.prod = FALSE
    ),
    {
      expect_true(app_dev())
      expect_false(app_prod())
    }
  )
})

test_that("test print_dev", {
  with_options(
    c(
      golem.app.prod = FALSE
    ),
    {
      expect_equal(print_dev("test"), "test")
      expect_type(print_dev("test"), "character")
    }
  )
})

test_that("test make_dev", {
  with_options(
    c(
      golem.app.prod = FALSE
    ),
    {
      sum_dev <- make_dev(sum)
      class(sum_dev)
      expect_equal(sum_dev(1, 2), 3)
      expect_type(sum_dev(1, 2), "double")
      expect_type(sum_dev, "closure")
    }
  )
})

test_that("test print_dev", {
  with_options(
    c(
      golem.app.prod = FALSE
    ),
    {
      expect_equal(print_dev("test"), "test")
      expect_type(print_dev("test"), "character")
    }
  )
})


test_that("test browser_button", {
  withr::with_options(
    c("golem.quiet" =  FALSE),{
    output <- capture_output_lines(browser_button())
  })
  expect_true(
    grepl('actionButton\\("browser", "browser"\\)', output[2])
  )
  expect_true(
    grepl('tags\\$script\\(\"\\$\\(\'#browser\'\\).hide\\(\\);\"\\)', output[3])
  )
  expect_true(
    grepl("observeEvent\\(input\\$browser", output[6])
  )
  expect_true(
    grepl("  browser()", output[7])
  )
  expect_true(
    grepl("run \\$\\('#browser'\\)\\.show\\(\\);", output[12])
  )
})
