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
usethis::use_test("add_function")
usethis::use_test("add_module")
usethis::use_test("add_dockerfile")
usethis::use_test("dev_function")
usethis::use_test("use_recomended")
usethis::use_test("favicon")
usethis::use_test("use_utils")
usethis::use_test("expect_function")
usethis::use_test("reload")
usethis::use_test("js")
usethis::use_test("aaadependencies")
usethis::use_test("create_golem")
usethis::use_test("config")

# Travis
usethis::use_travis()
usethis::use_coverage()

# Documentation
usethis::use_vignette("build-app-package")
usethis::use_vignette("e_golem_cheatsheet")

# pkgdown
usethis::use_pkgdown()
usethis::use_git_ignore("docs")
usethis::use_build_ignore("reference")
pkgdown::build_site()

# Dev
attachment::att_to_description(extra.suggests = c("pkgdown", "rcmdcheck", "covr", "DT"),
                               pkg_ignore = c("mypkg", "s"))


