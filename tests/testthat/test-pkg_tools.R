skip_if_not_installed("pkgload")

test_that("pkgtools works", {
  withr::with_dir(pkg, {
    expect_equal(pkgload::pkg_name(), fakename)
    expect_equal(as.character(pkgload::pkg_version()), "0.0.0.9000")
    # F-word windows path
    skip_on_os("windows")
    expect_equal(pkgload::pkg_path(), pkg)
  })
})
