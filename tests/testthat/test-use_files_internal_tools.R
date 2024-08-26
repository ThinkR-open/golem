test_that("copy_internal_file works", {
  testthat::expect_snapshot({
    testthat::with_mocked_bindings(
      copy_internal_file = function(path, where) {
        print(path)
        print(where)
      },
      {
        copy_internal_file(
          "~/here/this.css",
          "inst/app/this.css"
        )
      }
    )
  })
})
