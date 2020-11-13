# # For setting back old usethis settings
try({
  usethis::proj_set(orig_test)
  unlink(pkg, TRUE, TRUE)
})


