# Building a Prod-Ready, Robust Shiny Application.
# 
# Each step is optional. 
# 

# 2. All along your project

## 2.1 Add modules
## 
golem::add_module(name = "my_first_module") # Name of the module
golem::add_module( name = "my_other_module") # Name of the module

## 2.2 Add dependencies

usethis::use_package("pkg") # To call each time you need a new package

## 2.3 Add tests

usethis::use_test("app")

## 2.4 Add a browser button

golem::add_browser_button()

# 3. Documentation

## 3. Vignette
usethis::use_vignette("shinyexample")
devtools::build_vignettes()

## 3. Code coverage
usethis::use_travis()
usethis::use_appveyor()
usethis::use_coverage()

# You're now set! 
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")