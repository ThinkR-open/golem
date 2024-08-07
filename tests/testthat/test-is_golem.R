test_that("is_golem works", {
  to_create <- grep(
    "^(?!REMOVEME).*",
    list.files(
      system.file("shinyexample", package = "golem"),
      recursive = TRUE
    ),
    perl = TRUE,
    value = TRUE
  )
  run_quietly_in_a_dummy_golem({
     for (file in to_create) {
       file.create(
         file
       )
     }
    expect_true(
      is_golem(".")
    )
  })
  expect_false(
    is_golem(tempdir())
  )
})
