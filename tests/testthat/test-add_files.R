test_already_there_dance <- function(
  fun,
  filename,
  template
) {
  testthat::with_mocked_bindings(
    file_already_there_dance = function(...) {
      return(TRUE)
    },
    {
      expect_true(
        fun(
          filename,
          open = FALSE
        )
      )
    }
  )
}

test_add_file <- function(
  fun,
  file_with_extension,
  template = function(path, code = "oh no") {
    write(code, file = path, append = TRUE)
  },
  with_template = TRUE,
  output_suffix = ""
) {
  file_sans_extension <- tools::file_path_sans_ext(
    file_with_extension
  )
  expect_error(fun())
  fun(
    file_sans_extension,
    open = FALSE
  )
  expect_exists(
    file.path(
      "inst/app/www",
      sprintf(
        "%s%s",
        output_suffix,
        file_with_extension
      )
    )
  )
  test_already_there_dance(
    fun,
    file_sans_extension
  )
  if (with_template) {
    fun(
      sprintf(
        "tpl_%s",
        file_sans_extension
      ),
      open = FALSE,
      template = template
    )
    expect_exists(
      file.path(
        "inst/app/www",
        sprintf(
          "tpl_%s",
          file_with_extension
        )
      )
    )
    all_lines <- paste0(
      readLines(
        file.path(
          "inst/app/www",
          sprintf(
            "tpl_%s",
            file_with_extension
          )
        )
      ),
      collapse = " "
    )
    expect_true(
      grepl(
        "oh no",
        all_lines
      )
    )
  }
}

test_that("add_file works", {
  run_quietly_in_a_dummy_golem({
    test_add_file(
      add_js_file,
      "add_js_file.js"
    )

    test_add_file(
      add_js_handler,
      "add_js_handler.js"
    )

    test_add_file(
      add_js_input_binding,
      "add_js_input_binding.js",
      with_template = FALSE,
      output_suffix = "input-"
    )

    test_add_file(
      add_js_output_binding,
      "add_js_output_binding.js",
      with_template = FALSE,
      output_suffix = "output-"
    )

    test_add_file(
      add_css_file,
      "add_css_file.css"
    )

    test_add_file(
      add_sass_file,
      "add_sass_file.sass"
    )

    test_add_file(
      add_empty_file,
      "add_empty_file"
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
    test_already_there_dance(
      add_html_template,
      "template.html"
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
    test_already_there_dance(
      add_partial_html_template,
      "partial_template.html"
    )

    for (
      file in c(
        "warn_add_js_file.js",
        "warn_add_css_file.css",
        "warn_add_sass_file.sass",
        "warn_template.html"
      )
    ) {
      expect_warning(
        add_empty_file(
          file,
          open = FALSE
        )
      )
    }
    res <- expect_warning(
      add_ui_server_files(
        pkg = "."
      )
    )
    expect_exists(
      "inst/app/ui.R"
    )
    expect_exists(
      "inst/app/server.R"
    )
    res <- expect_warning(
      add_ui_server_files(
        pkg = "."
      )
    )
  })
})

test_that(
  "add_empty_file throws a warning if using an extension that is already handled by another function",
  {
    run_quietly_in_a_dummy_golem({
      for (file in c(
        "add_js_file.js",
        "add_css_file.css",
        "add_sass_file.sass",
        "template.html"
      )) {
        expect_warning(
          add_empty_file(
            file,
            open = FALSE
          )
        )
      }
    })
  }
)