test_that("not_in works", {
  expect_true(1 %not_in% 2:10)
  expect_false(1 %not_in% 1:10)
})

test_that("not_null works", {
  expect_true(not_null(1))
  expect_false(not_null(NULL))
})

test_that("not_na works", {
  expect_true(not_na(1))
  expect_false(not_na(NA))
})

test_that("drop_nulls works", {
  expect_equal(
    drop_nulls(
      list(x = NULL, y = 2)
    ),
    list(y = 2)
  )
})

test_that("%||% works", {
  expect_equal(
    NULL %||% 1,
    1
  )
  expect_equal(
    2 %||% 1,
    2
  )
})

test_that("%|NA|% works", {
  expect_equal(
    NA %|NA|% 1,
    1
  )
  expect_equal(
    2 %|NA|% 1,
    2
  )
})

test_that("rv and rvtl work", {
  expect_true(
    inherits(rv, "function")
  )
  expect_true(
    inherits(rvtl, "function")
  )

  rv_test_1 <- rv(a = "a", b = 2)
  rv_test_2 <- reactiveValues(a = "a", b = 2)
  shiny::reactiveConsole(TRUE)
  expect_identical(rv_test_1$a, rv_test_2$a)
  expect_identical(rv_test_1$b, rv_test_2$b)
  expect_identical(
    rvtl(rv_test_2),
    shiny::reactiveValuesToList(rv_test_1)
  )
  shiny::reactiveConsole(FALSE)
})
