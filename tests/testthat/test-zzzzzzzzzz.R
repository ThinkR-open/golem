# # For setting back old usethis settings
try({
  unlink(pkg, TRUE, TRUE)
  options("usethis.quiet" = old_usethis.quiet)
})
