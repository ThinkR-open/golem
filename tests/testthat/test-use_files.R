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
      use_external_file(
        url = "https://raw.githubusercontent.com/ilyaZar/golem/fix-1058/inst/utils/testfile_template_plainfile.txt",
        name = "testfile_template_plainfile.txt"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_plainfile.txt"
      )
      expect_identical(
        test_file_download,
        "Some text."
      )

      # II. test the external ".html" file download
      use_external_html_template(
        url = "https://raw.githubusercontent.com/ilyaZar/golem/fix-1058/inst/utils/testfile_template_html.html",
        name = "testfile_template_plainfile.html"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_plainfile.html"
      )
      expect_identical(
        test_file_download,
        c("<!DOCTYPE html>", "<html>", "<body>", "",
          "<h1>My First Heading</h1>", "", "<p>My first paragraph.</p>", "",
          "</body>","</html>")
      )

      # III. test the external ".js" file download
      use_external_js_file(
        url = "https://raw.githubusercontent.com/ilyaZar/golem/fix-1058/inst/utils/testfile_template_js.js",
        name = "testfile_template_js.js"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_js.js"
      )
      expect_identical(
        test_file_download,
        c("const myHeading = document.querySelector(\"h1\");",
          "myHeading.textContent = \"Hello world!\";")
      )

      # IV. test the external ".css" file download
      use_external_css_file(
        url = "https://raw.githubusercontent.com/ilyaZar/golem/fix-1058/inst/utils/testfile_template_css.css",
        name = "testfile_template_css.css"
      )
      test_file_download <- readLines(
        "inst/app/www/testfile_template_css.css"
      )
      expect_identical(
        test_file_download,
        c(" body {",
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
      unlink(path_dummy_golem, recursive = TRUE)
    }
  )
})
