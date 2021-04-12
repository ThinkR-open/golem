print(Sys.getenv())
cat("\n")
#rstudioapi::jobRunScript(here::here("inst/mantests/build.R"), workingDir = here::here())
cat_ok <- function() cli::cat_bullet("Passed", bullet = "tick", bullet_col = "green")

# We prevent the random name from having 
# ui or server inside it 
safe_let <- function(){
  letters[-c(5,9,18,19,21,22)]
}

## fake package
fakename <- sprintf(
  "%s%s",
  paste0(sample(safe_let(), 10, TRUE), collapse = ""),
  gsub("[ :-]", "", Sys.time())
)

# Just so that I can use this script locally too,
# I set a temporary lib
# 
cli::cat_rule("Set up for lib")

if (Sys.getenv("CI", "local") == "local"){
  # If I'm on the CI, we don't change the lib
  temp_app <- file.path(getwd(), "inst", "golemmetrics")
  temp_lib <- .libPaths()
} else {
  temp_app <- file.path(getwd(), "inst", "golemmetrics")
  temp_lib <- file.path(tempdir(), "temp_lib")
  .libPaths(c(temp_lib,.libPaths()))
}

cli::cat_bullet(temp_app)
# This will be our golem app


if (dir.exists(temp_app)) {
  unlink(temp_app, TRUE, TRUE)
}

dir.create(temp_lib, recursive = TRUE)

install.packages(
  c("remotes", "desc", "testthat", "cli", "fs", "cranlogs"), 
  lib = temp_lib, 
  repo = "https://cran.rstudio.com/"
)

cli::cat_rule("Install golem")

library(remotes, lib.loc = temp_lib)
library(desc, lib.loc = temp_lib)
library(testthat, lib.loc = temp_lib)
library(cli, lib.loc = temp_lib)
library(fs, lib.loc = temp_lib)

# We'll need to install golem from the current branch because 
# otherwise the dependency tree breaks
# install_github(
#   "ThinkR-open/golem",
#   ref = Sys.getenv("GITHUB_BASE_REF", "dev"), 
#   force = TRUE,
#   lib.loc = temp_lib
# )

# Installing the current version of golem
install_local(
  lib.loc = temp_lib
)

cli::cat_rule("Install crystalmountains")

install_github(
  "thinkr-open/crystalmountains", 
  lib.loc = temp_lib
)

# Going to the temp dir and create a new golem
cli::cat_rule("Creating a golem based app")

library(golem)

create_golem(
  temp_app, 
  open = FALSE, 
  project_hook = crystalmountains::golem_hook
)

expect_true(
  dir.exists(temp_app)
)

old <- setwd(temp_app)

here::set_here(temp_app)

usethis::use_build_ignore(".here")

if (Sys.getenv("GITHUB_BASE_REF") == ""){
  usethis::use_dev_package(
    "golem", 
    remote = "github::ThinkR-open/golem@dev"
  )
} else {
  usethis::use_dev_package(
    "golem", 
    remote = sprintf(
      "github::ThinkR-open/golem@dev",
      Sys.getenv("GITHUB_BASE_REF")
    )
  )
}



cat(
  readLines("DESCRIPTION"),
  sep = "\n"
)


here::set_here(temp_app)

usethis::use_build_ignore(".here")

usethis::use_dev_package("golem")

cat(
  readLines("DESCRIPTION"),
  sep = "\n"
)

cat_ok()


cli::cat_rule("Checking the hook has set the MIT licence")
expect_true(
  file.exists("LICENSE")
)
expect_true(
  desc::desc_get("License") == "MIT + file LICENSE" 
)
cat_ok()

cli::cat_rule("Checking the DESCRIPTION is correct")
expect_true(
  desc::desc_get("Package") == "golemmetrics" 
)
expect_true(
  desc::desc_get("Title") == "An Amazing Shiny App" 
)
expect_true(
  all(desc::desc_get_deps()$package %in% c("config", "golem", "shiny"))
)
cat_ok()

cli::cat_rule("Checking all files are here")

expected_files <- c(
  "DESCRIPTION", 
  "NAMESPACE",
  "R", 
  "R/app_config.R", 
  "R/app_server.R", 
  "R/app_ui.R", 
  "R/run_app.R", 
  "dev", 
  "dev/01_start.R", 
  "dev/02_dev.R", 
  "dev/03_deploy.R", 
  "dev/run_dev.R", 
  "inst", 
  "inst/app", 
  "inst/app/www", 
  "inst/app/www/favicon.ico", 
  "inst/golem-config.yml",
  "man", 
  "man/run_app.Rd"
)
actual_files <- fs::dir_ls(recurse = TRUE)

for (i in expected_files) {
  expect_true(i %in% actual_files)
}
cat_ok()

# Going through 01_start.R ----
# 
cli::cat_rule("Going through 01_start.R")
cli::cat_line()

golem::fill_desc(
  pkg = temp_app,
  pkg_name = "golemmetrics", # The Name of the package containing the App 
  pkg_title = "A App with Metrics about 'Golem'", # The Title of the package containing the App 
  pkg_description = "Read metrics about {golem}.", # The Description of the package containing the App 
  author_first_name = "Colin", # Your First Name
  author_last_name = "Fay", # Your Last Name
  author_email = "colin@thinkr.fr", # Your Email
  repo_url = NULL # The URL of the GitHub Repo (optional) 
)     

cli::cat_rule("checking package name")
expect_equal(
  desc::desc_get_field("Package"), 
  "golemmetrics"
)
cat_ok()
cli::cat_rule("checking pkg_title name")
expect_equal(
  desc::desc_get_field("Title"), 
  "A App with Metrics about 'Golem'"
)
cat_ok()
cli::cat_rule("checking package name")
expect_equal(
  desc::desc_get_field("Description"), 
  "Read metrics about {golem}."
)
cat_ok()
cli::cat_rule("checking package name")
expect_equal(
  as.character(desc::desc_get_author()), 
  "Colin Fay <colin@thinkr.fr> [cre, aut]"
)
cat_ok()
cli::cat_rule("checking package version")
expect_equal(
  as.character(desc::desc_get_version()), 
  "0.0.0.9000"
)
cat_ok()

cli::cat_rule("set_golem_options")

golem::set_golem_options()
expect_equal(
  golem::get_golem_wd(), 
  here::here()
)
expect_equal(
  golem::get_golem_name(), 
  "golemmetrics"
)
expect_equal(
  golem::get_golem_version(), 
  "0.0.0.9000"
)
expect_false(
  golem::app_prod()
)

cat_ok()

cli::cat_rule("Create Common Files")

#usethis::use_mit_license( "Golem User" ) 

expect_equal(
  desc::desc_get_field("License"), 
  "MIT + file LICENSE"
)
expect_true(
  file.exists("LICENSE")
)
usethis::use_readme_rmd( open = FALSE )
expect_true(
  file.exists("README.Rmd")
)

usethis::use_code_of_conduct()
expect_true(
  file.exists("CODE_OF_CONDUCT.md")
)

usethis::use_news_md( open = FALSE )
expect_true(
  file.exists("NEWS.md")
)

cat_ok()

cli::cat_rule("use_recommended")

golem::use_recommended_tests(spellcheck = FALSE)
expect_true(
  dir.exists("tests")
)

golem::use_recommended_deps()

cat_ok()

# Going through 02_dev ----
cli::cat_rule("Going through 01_start.R")

cli::cat_rule("Testing usepackage")
if (!requireNamespace("cranlogs")){
  install.packages("cranlogs")
}
usethis::use_package( "cranlogs" )
expect_true(
  "cranlogs" %in% desc::desc_get_deps()$package
)
cat_ok()

cli::cat_rule("Testing modules")
golem::add_module( 
  name = "main", 
  open = FALSE, 
  module_template = crystalmountains::module_template, 
  fct = "golem_logs", 
  js = "golem_stars", 
  utils = "pretty_num"
)

expect_true(
  file.exists("R/mod_main.R")
)

expect_true(
  file.exists("R/mod_main_fct_golem_logs.R")
)
write(
  readLines(
    system.file(
      "golemlogs", 
      package = "crystalmountains"
    )
  ), 
  "R/mod_main_fct_golem_logs.R", 
  append = TRUE
)
expect_true(
  file.exists("R/mod_main_utils_pretty_num.R")
)
write(
  readLines(
    system.file(
      "prettynum", 
      package = "crystalmountains"
    )
  ), 
  "R/mod_main_utils_pretty_num.R", 
  append = TRUE
)
expect_true(
  file.exists("inst/app/www/golem_stars.js")
)
unlink("inst/app/www/golem_stars.js", TRUE, TRUE)

golem::document_and_reload()

cat_ok()

golem::add_fct( "helpers", open = FALSE) 
expect_true(
  file.exists("R/fct_helpers.R")
)
unlink("R/fct_helpers.R", TRUE, TRUE)
golem::add_utils( "helpers", open = FALSE)
expect_true(
  file.exists("R/utils_helpers.R")
)
unlink("R/utils_helpers.R", TRUE, TRUE)

golem::add_js_file( "script", template = crystalmountains::js_file)
golem::add_js_handler( "handlers", template = crystalmountains::js_handler)
golem::add_css_file( "custom", template = crystalmountains::css_file)

cli::cat_rule("Testing and installing package")
golem::document_and_reload()
devtools::test()
cat_ok()

cli::cat_rule("Testing 03_dev")
devtools::check()
remotes::install_local(force = TRUE)
targz <- devtools::build()
remotes::install_local(targz)

cli::cat_rule("Testing 03_dev")

cat_ok()

if (Sys.info()['sysname'] == "Linux"){
  golem::add_rstudioconnect_file()
  golem::add_dockerfile(
    repos = "https://packagemanager.rstudio.com/all/__linux__/focal/latest",
    from = "rocker/shiny-verse:4.0.4", 
    extra_sysreqs = c("libxml2-dev"),
    open = FALSE
  )
  usethis::use_git()
  dir.create(".git/hooks", recursive = TRUE)
  file.create(".git/hooks/pre-commit")
  install.packages("rsconnect")
  rsconnect::writeManifest()
  install.packages("knitr")
  knitr::knit("README.Rmd")
}

# Restore old wd

# unlink(temp_app, TRUE, TRUE)
# unlink(temp_golem, TRUE, TRUE)
# unlink(temp_lib, TRUE, TRUE)

cli::cat_rule("Completed")
