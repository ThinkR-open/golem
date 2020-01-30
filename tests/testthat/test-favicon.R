context("tests use_favicon")

test_that("test use_favicon",{
  with_dir(pkg,{
    use_favicon()
    expect_true(file.exists("inst/app/www/favicon.ico"))
    lapply(
      c(
        "test.jpeg",
        "test.bmp",
        "test.gif",
        "test.tiff"
      ),
      function(.x) {expect_error(
        use_favicon(path = .x)
      )}
    )
    golem::remove_favicon()
    expect_false(file.exists("inst/app/www/favicon.ico"))
  })
})

test_that("test favicon",{
  with_dir(pkg,{
    expect_is(
      favicon("jean","jean"),
      "shiny.tag"
    )
  })
})