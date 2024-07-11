test_that("install_dev_deps works", {
  withr::with_temp_libpaths({
    install_dev_deps(
      force_install = TRUE,
      repos = "https://cran.rstudio.com"
    )

    paks <- unique(
      c(
        "usethis",
        "pkgload",
        "dockerfiler",
        "devtools",
        "roxygen2",
        "attachment",
        "rstudioapi",
        "here",
        "fs",
        "desc",
        "pkgbuild",
        "processx",
        "rsconnect",
        "testthat",
        "rstudioapi"
      )
    )
    for (
      pak in paks
    ) {
      expect_true(
        rlang::is_installed(pak)
      )
    }
  })
})
