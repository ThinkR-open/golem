test_that("download_external(url, where) works", {
  testthat::expect_snapshot({
    testthat::with_mocked_bindings(
      utils_download_file = function(url, where) {
        print(url)
        print(where)
      },{
        download_external(
          "https://www.google.com",
          "inst/app/www/google.html"
        )
      }
    )
  })
})
