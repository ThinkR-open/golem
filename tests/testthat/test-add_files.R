test_that("add_file works", {
  run_quietly_in_a_dummy_golem({
    add_js_file(
      "add_js_file",
      open = FALSE
    )
    expect_exists(
      file.path(
        "inst/app/www",
        "add_js_file.js"
      )
    )
    add_js_handler(
      "add_js_handler",
      open = FALSE
    )
    expect_exists(
      file.path(
        "inst/app/www",
        "add_js_handler.js"
      )
    )

    add_js_input_binding(
      "add_js_input_binding",
      open = FALSE
    )

    expect_exists(
      file.path(
        "inst/app/www",
        "input-add_js_input_binding.js"
      )
    )

    add_js_output_binding(
      "add_js_output_binding",
      open = FALSE
    )

    expect_exists(
      file.path(
        "inst/app/www",
        "output-add_js_output_binding.js"
      )
    )
    add_css_file(
      "add_css_file",
      open = FALSE
    )
    expect_exists(
      file.path(
        "inst/app/www",
        "add_css_file.css"
      )
    )

    add_sass_file(
      "add_sass_file",
      open = FALSE
    )

    expect_exists(
      file.path(
        "inst/app/www",
        "add_sass_file.sass"
      )
    )

    add_empty_file(
      "add_empty_file",
      open = FALSE
    )

    expect_exists(
      file.path(
        "inst/app/www",
        "add_empty_file"
      )
    )

     add_html_template(
       open = FALSE
     )

     expect_exists(
       file.path(
         "inst/app/www",
         "template.html"
       )
     )

     add_partial_html_template(
       open = FALSE
     )

     expect_exists(
       file.path(
         "inst/app/www",
         "partial_template.html"
       )
     )
  })
})
