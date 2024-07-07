test_that("is_golem works", {
  dummy_golem <- create_dummy_golem()
  to_create <- grep(
    "^(?!REMOVEME).*",
    list.files(
      system.file("shinyexample", package = "golem"),
      recursive = TRUE
    ),
    perl = TRUE,
    value = TRUE
  )
  withr::with_dir(
    dummy_golem,
    {
      for (file in to_create) {
        file.create(
          file
        )
      }
    }
  )
  expect_true(
    is_golem(
      dummy_golem
    )
  )
  unlink(dummy_golem, TRUE, TRUE)
  expect_false(
    is_golem(tempdir())
  )
})
