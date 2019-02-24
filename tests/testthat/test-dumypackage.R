# context("test-dumypackage")
# 
# test_that("created package is valid", {
#   temp <- file.path(tempdir(),"plop")
#   create_shiny_template(path = temp)
#   old <- setwd(normalizePath(temp))
#   on.exit(setwd(old))
#   devtools::document()
#   usethis::use_mit_license(name = "nobody")
#   out <- rcmdcheck::rcmdcheck(path = temp,
#                               build_args = 
#                               c('--no-manual'),
#                               check_dir = file.path(tempdir(),"plop2"))
# 
# e <- grep("PDF", out$errors, value = TRUE,invert = TRUE)
# w <- grep("PDF", out$warnings, value = TRUE,invert = TRUE)
# expect_length(e,n = 0)
# expect_length(w,n = 0)
# setwd(old)
#   })
