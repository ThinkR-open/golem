# For setting back old usethis settings
if (!identical(Sys.getenv("TRAVIS"), "true")) {
  usethis::proj_set(orig_test)
}

unlink(pkg, TRUE, TRUE)