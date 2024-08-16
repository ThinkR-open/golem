test_that("after_creation_msg works", {
  expect_snapshot({
    after_creation_message_generic(
      "mypkg",
      "inst/app/www",
      "myjs"
    )
    after_creation_message_js(
      "mypkg",
      "inst/app/www",
      "myjs"
    )
    after_creation_message_css(
      "mypkg",
      "inst/app/www",
      "mycss"
    )
    after_creation_message_sass(
      "mypkg",
      "inst/app/www",
      "mysass"
    )
    after_creation_message_html_template(
      "mypkg",
      "inst/app/www",
      "myhtml"
    )
    testthat::with_mocked_bindings(
      fs_path_abs = paste,
      {
        after_creation_message_any_file(
          "mypkg",
          "inst/app/www",
          "myhtml"
        )
      }
    )
    file_created_dance(
      "inst/app/www",
      after_creation_message_sass,
      "mypkg",
      "inst/app/www",
      "mysass",
      open_file = FALSE,
      open_or_go_to = FALSE
    )
    file_already_there_dance(
      "inst/app/www",
      open_file = FALSE
    )
  })
})
