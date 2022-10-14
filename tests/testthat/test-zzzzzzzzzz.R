# # For setting back old usethis settings
try({
  if (exists("orig_test")) {
    usethis::proj_set(orig_test)
  }
  if (exists("pkg")) {
    try({
      unlink(pkg, TRUE, TRUE)
    })
  }

  options("usethis.quiet" = old_usethis.quiet)
})
