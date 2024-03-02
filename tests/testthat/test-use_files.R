test_that("use_external_XXX_files() function family works properly", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )
  with_dir(
    path_dummy_golem,
    {
      # I. test the external ".txt" file download
      # I.A standard case
      use_external_file(
        url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_plainfile.txt"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_plainfile"
      )
      expect_identical(
        test_file_download,
        "Some text."
      )
      # I.B corner case: file already exists
      expect_false(
        use_external_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_plainfile.txt",
          name = "testfile_template_plainfile.txt"
        )
      )
      # I.C corner case: dir already exists
      expect_false(
        use_external_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_plainfile.txt",
          name = "testfile_template_plainfile3.txt",
          dir = "inst/app/www2"
        )
      )

      # II. test the external ".html" file download
      # II.A standard case
      use_external_html_template(
        url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_html.html",
        name = "testfile_template_html.html"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_html.html"
      )
      expect_identical(
        test_file_download,
        c(
          "<!DOCTYPE html>",
          "<html>",
          "<body>",
          "",
          "<h1>My First Heading</h1>",
          "",
          "<p>My first paragraph.</p>",
          "",
          "</body>",
          "</html>"
        )
      )
      # II.B corner case: file already exists
      expect_false(
        use_external_html_template(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_html.html",
          name = "testfile_template_html.html"
        )
      )
      # II.C corner case: dir already exists
      expect_false(
        use_external_html_template(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_html.html",
          name = "testfile_template_html2.html",
          dir = "inst/app/www2"
        )
      )

      # III. test the external ".js" file download
      # III.A standard case
      use_external_js_file(
        url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_js.js"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_js.js"
      )
      expect_identical(
        test_file_download,
        c(
          "const myHeading = document.querySelector(\"h1\");",
          "myHeading.textContent = \"Hello world!\";"
        )
      )
      # III.B corner case: file already exists
      expect_false(
        use_external_js_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_js.js",
          name = "testfile_template_js.js"
        )
      )
      # III.C corner case: dir already exists
      expect_false(
        use_external_js_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_js.js",
          name = "testfile_template_js2.js",
          dir = "inst/app/www2"
        )
      )
      # III.D corner case: URL does not have extension ".js"
      expect_false(
        use_external_js_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_js",
          name = "testfile_template_js3.js"
        )
      )

      # IV. test the external ".css" file download
      # IV.A standard case
      use_external_css_file(
        url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_css.css"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_css.css"
      )
      expect_identical(
        test_file_download,
        c(
          " body {",
          "  background-color: lightblue;",
          "}",
          "",
          "h1 {",
          "  color: white;",
          "  text-align: center;",
          "}",
          "",
          "p {",
          "  font-family: verdana;",
          "  font-size: 20px;",
          "}"
        )
      )
      # IV.B corner case: file already exists
      expect_false(
        use_external_css_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_css.css",
          name = "testfile_template_css.css"
        )
      )
      # IV.C corner case: dir already exists
      expect_false(
        use_external_css_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_css.css",
          name = "testfile_template_css2.css",
          dir = "inst/app/www2"
        )
      )
      # IV.D corner case: URL does not have extension ".css"
      expect_false(
        use_external_css_file(
          url = "https://raw.githubusercontent.com/ThinkR-open/golem/dev/inst/utils/testfile_template_css",
          name = "testfile_template_css3.css"
        )
      )

      unlink(path_dummy_golem, recursive = TRUE)
    }
  )
})
test_that("use_internal_XXX_files() function family works properly", {
  path_dummy_golem <- tempfile(pattern = "dummygolem")
  create_golem(
    path = path_dummy_golem,
    open = FALSE
  )
  dir.create(file.path(path_dummy_golem, "tmp_dump_testfiles"))
  file.copy(
    from = file.path(
      .libPaths()[1],
      "golem",
      "utils",
      c(
        "testfile_template_plainfile.txt",
        "testfile_template_html.html",
        "testfile_template_js.js",
        "testfile_template_css.css"
      )
    ),
    to = file.path(
      path_dummy_golem,
      "tmp_dump_testfiles"
    )
  )
  with_dir(
    path_dummy_golem,
    {
      # I. test the internal ".txt" file usage
      # I.A standard case
      use_internal_file(
        path = file.path(
          path_dummy_golem,
          "tmp_dump_testfiles",
          "testfile_template_plainfile.txt"
        )
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_plainfile.txt"
      )
      expect_identical(
        test_file_download,
        "Some text."
      )
      # I.B corner case: file already exists
      expect_false(
        use_internal_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_plainfile.txt"
          ),
          name = "testfile_template_plainfile.txt"
        )
      )
      # I.C corner case: dir already exists
      expect_false(
        use_internal_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_plainfile.txt"
          ),
          name = "testfile_template_plainfile2.txt",
          dir = "inst/app/www2"
        )
      )

      # II. test the internal ".html" file usage
      # II.A standard case
      use_internal_html_template(
        path = file.path(
          path_dummy_golem,
          "tmp_dump_testfiles",
          "testfile_template_html.html"
        ),
        name = "testfile_template_html.html"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_html.html"
      )
      expect_identical(
        test_file_download,
        c(
          "<!DOCTYPE html>",
          "<html>",
          "<body>",
          "",
          "<h1>My First Heading</h1>",
          "",
          "<p>My first paragraph.</p>",
          "",
          "</body>",
          "</html>"
        )
      )
      # II.B corner case: file already exists
      expect_false(
        use_internal_html_template(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_html.html"
          ),
          name = "testfile_template_html.html"
        )
      )
      # II.C corner case: dir already exists
      expect_false(
        use_internal_html_template(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_html.html"
          ),
          name = "testfile_template_html2.html",
          dir = "inst/app/www2"
        )
      )

      # III. test the internal ".js" file usage
      # III.A standard case
      use_internal_js_file(
        path = file.path(
          path_dummy_golem,
          "tmp_dump_testfiles",
          "testfile_template_js.js"
        )
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_js.js"
      )
      expect_identical(
        test_file_download,
        c(
          "const myHeading = document.querySelector(\"h1\");",
          "myHeading.textContent = \"Hello world!\";"
        )
      )
      # III.B corner case: file already exists
      expect_false(
        use_internal_js_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_js.js"
          ),
          name = "testfile_template_js.js"
        )
      )
      # III.C corner case: dir already exists
      expect_false(
        use_internal_js_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_js2.js"
          ),
          name = "testfile_template_js.js",
          dir = "inst/app/www2"
        )
      )
      # III.D corner case: file path does not have extension ".js"
      expect_false(
        use_internal_js_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_js"
          ),
          name = "testfile_template_js3.js"
        )
      )

      # IV. test the internal ".css" file usage
      # IV.A standard case
      use_internal_css_file(
        path = file.path(
          path_dummy_golem,
          "tmp_dump_testfiles",
          "testfile_template_css.css"
        )
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_css.css"
      )
      expect_identical(
        test_file_download,
        c(
          " body {",
          "  background-color: lightblue;",
          "}",
          "",
          "h1 {",
          "  color: white;",
          "  text-align: center;",
          "}",
          "",
          "p {",
          "  font-family: verdana;",
          "  font-size: 20px;",
          "}"
        )
      )
      # IV.B corner case: file already exists
      expect_false(
        use_internal_css_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_css.css"
          ),
          name = "testfile_template_css.css"
        )
      )
      # IV.C corner case: dir already exists
      expect_false(
        use_internal_css_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_css.css"
          ),
          name = "testfile_template_css2.css",
          dir = "inst/app/www2"
        )
      )
      # IV.D corner case: file path does not have extension ".css"
      expect_false(
        use_internal_css_file(
          path = file.path(
            path_dummy_golem,
            "tmp_dump_testfiles",
            "testfile_template_css"
          ),
          name = "testfile_template_css3.css"
        )
      )

      unlink(path_dummy_golem, recursive = TRUE)
    }
  )
})
