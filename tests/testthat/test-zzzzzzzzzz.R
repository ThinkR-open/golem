# For setting back old usethis settings
if (dir.exists(orig_test)){
  usethis::proj_set(orig_test)
}

unlink(pkg, TRUE, TRUE)