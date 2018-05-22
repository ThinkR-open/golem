# the goal of this file is to have a trace of all devtools/usethis 
# call you make for your project

# Hide devtools_history from build
usethis::use_build_ignore("devtools_history.R")

# Add packages
usethis::use_pipe()
# devtools::use_data_raw()
devtools::use_package("shiny")
devtools::use_package("DT")
devtools::use_package("stats")
devtools::use_package("graphics")
usethis::use_tidy_description()
devtools::use_package("glue")

# Add tests
# Todo: add tests for modules
devtools::use_test("app")

