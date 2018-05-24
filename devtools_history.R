library(usethis)

devtools::use_package("devtools")
usethis::use_build_ignore("devtools_history.R")
usethis::use_build_ignore("readme_figures/")
usethis::use_readme_rmd()
usethis::use_mit_license(name = "ThinkR")
use_code_of_conduct()
use_lifecycle_badge("Experimental")
