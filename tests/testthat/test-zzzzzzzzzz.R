# # For setting back old usethis settings
try({
  unlink("README.Rmd", TRUE, TRUE)
  unlink("README.md", TRUE, TRUE)
  unlink(pkg, TRUE, TRUE)
  options("usethis.quiet" = old_usethis.quiet)
})
