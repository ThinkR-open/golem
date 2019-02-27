library(usethis)

devtools::use_package("devtools")
devtools::use_package("usethis")
devtools::use_package("glue")
devtools::use_package("desc")
usethis::use_package("crayon")
usethis::use_build_ignore("devtools_history.R")
usethis::use_build_ignore("readme_figures/")
usethis::use_readme_rmd()
usethis::use_mit_license(name = "ThinkR")
use_code_of_conduct()
use_lifecycle_badge("Experimental")

usethis::use_test()
usethis::use_test("desc")

# Travis
usethis::use_travis()

# Documentation
usethis::use_vignette("build-app-package")

# pkgdown
usethis::use_pkgdown()
usethis::use_git_ignore("docs")
pkgdown::build_site()

# Dev
attachment::att_to_description(extra.suggests = c("pkgdown", "rcmdcheck"), pkg_ignore = c("mypkg"))
devtools::check()



