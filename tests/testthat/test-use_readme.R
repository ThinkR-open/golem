test_that("generate_readme_tmpl works", {
  res <- generate_readme_tmpl("my_pkg")
  expect_true(
    grepl("my_pkg", paste(res, collapse = " "))
  )
  expect_true(
    grepl("my_pkg::run_app()", paste(res, collapse = " "))
  )
  expect_true(
    grepl("covr::package_coverage", paste(res, collapse = " "))
  )
  expect_true(
    grepl("unloadNamespace", paste(res, collapse = " "))
  )
  expect_true(
    grepl("devtools::check", paste(res, collapse = " "))
  )
})


test_that("check_overwrite works", {
  this_file_will_be_removed <- tempfile(fileext = ".Rmd")
  write("hello world", this_file_will_be_removed)

  expect_error(
    check_overwrite(FALSE, this_file_will_be_removed),
    "README.Rmd already exists. Set `overwrite = TRUE` to overwrite."
  )
  # Check if file still exists
  expect_true(file.exists(golem_sys("utils/empty_readme.Rmd")))

  # Remove file via check_overwrite setting overwrite=TRUE
  check_overwrite(TRUE, this_file_will_be_removed)
  # Check that file is indeed removed
  expect_false(file.exists(this_file_will_be_removed))
})

test_that("use_readme_rmd works", {
  withr::with_dir(pkg, {
    expect_true(
      use_readme_rmd(
        open = FALSE,
        overwrite = TRUE,
        pkg = getwd(),
        pkg_name = "rand_name"
      )
    )
    expect_true(
      file.exists("README.Rmd")
    )
  })
})
