# rstudioapi::jobRunScript(here::here("inst/mantests/build.R"), workingDir = here::here())
cat_ok <- function() cli::cat_bullet("Passed", bullet = "tick", bullet_col = "green")

# Just so that I can use this script locally too,
# I set a temporary lib
# 
cli::cat_rule("Set up for lib")

temp_lib <- file.path(tempdir(), "temp_lib")

# This will be our mock golem
temp_golem <- file.path(tempdir(), "temp_golem")

if (dir.exists(temp_golem)) {
  unlink(temp_golem, TRUE, TRUE)
}

# This will be our golem app
temp_app <- file.path(tempdir(), "golemmetrics")

if (dir.exists(temp_app)) {
  unlink(temp_app, TRUE, TRUE)
}

dir.create(temp_lib, recursive = TRUE)

install.packages(
  c("remotes", "desc", "testthat", "cli", "fs"), 
  lib = temp_lib, 
  repo = "https://cran.rstudio.com/"
)

cli::cat_rule("Load pack")
library(remotes, lib.loc = temp_lib)
library(desc, lib.loc = temp_lib)
library(testthat, lib.loc = temp_lib)

cli::cat_rule("Install crystalmountains")
remotes::install_github("thinkr-open/crystalmountains")

cli::cat_rule("Copy golem to temp_golem and install it")
dir.create(temp_golem, recursive = TRUE)
fs::dir_copy(".", temp_golem, overwrite = TRUE)
old_wd <- setwd(temp_golem)
install_local(lib = temp_lib, upgrade = "never", force = TRUE)
cat_ok()

# Making sure we have the current version
cli::cat_rule("Checking golem version")
expect_equal(
  packageVersion("golem", lib = temp_lib),
  desc_get_version()
)
cat_ok()

# Going to the temp dir and create a new golem
cli::cat_rule("Creating a golem based app")

library(golem, lib.loc = temp_lib)

create_golem(temp_app, open = FALSE, project_hook = crystalmountains::golem_hook)
expect_true(
  dir.exists(temp_app)
)
setwd(temp_app)
here::set_here(getwd())
usethis::use_build_ignore(".here")
devtools::check()
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

expected_files <- c("DESCRIPTION", "NAMESPACE", "R", "R/app_config.R", "R/app_server.R", "R/app_ui.R", "R/run_app.R", "dev", "dev/01_start.R", "dev/02_dev.R", "dev/03_deploy.R", "dev/run_dev.R", "inst", "inst/app", "inst/app/www", "inst/app/www/favicon.ico", "inst/golem-config.yml", "man", "man/run_app.Rd")
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

usethis::use_mit_license( name = "Golem User" )  # You can set another license here

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

devtools::test()
devtools::check()

golem::use_recommended_deps()

cat_ok()

# Going through 02_dev ----
cli::cat_rule("Going through 01_start.R")

cli::cat_rule("Testing usepackage")
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

expect_true(
  file.exists("R/mod_main.R")
)

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

golem::add_dockerfile()
system("docker build -t golemmetrics .")
cat_ok()

# Restore old wd
setwd(old_wd)
unlink(temp_app, TRUE, TRUE)
unlink(temp_golem, TRUE, TRUE)
unlink(temp_lib, TRUE, TRUE)

cli::cat_rule("Completed")