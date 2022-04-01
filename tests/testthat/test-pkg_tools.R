test_that("pkgtools works", {
  withr::with_dir(pkg, {
    expect_equal(pkg_name(), fakename)
    expect_equal(pkg_version(), "0.0.0.9000")
    expect_equal(pkg_path(), pkg)
  })
})
