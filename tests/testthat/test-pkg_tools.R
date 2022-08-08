test_that("pkgtools works", {
  withr::with_dir(pkg, {
    expect_equal(pkg_name(), fakename)
    expect_equal(pkg_version(), "0.0.0.9000")
    # F-word windows path
    skip_on_os("windows")
    expect_equal(pkg_path(), pkg)
  })
})
