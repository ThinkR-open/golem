# golem 0.0.1.5000+

## Changes 

* The dev files are now splitted in three - start / dev / deploy

* Every function that adds a file now check if the file already exists, and ask the user if they want to overwrite it (#15)

* Every module is now named mod_x_ui / mod_x_server, for consistency.

* You can now create package with "illegal" names, using the command line `golem::create_shiny_template()`. #18

* `add_browser_button()` is now named `browser_button()`, so that all the `add_*` function are only reserved for function adding files to the `golem`.

+ `add_*_files` now check if the folder exists, if not suggests to create it. #36

## New funs

* Added `set_golem_options()` to add local options used internally by {golem} && added it to the `01_start.R`. #49

* Added `add_dockerfile()` to create a Dockerfile from a DESCRIPTION.

* Added `add_dockerfile_shinyproxy()` to create a Dockerfile from a DESCRIPTION, to be used in Shiny Proxy.

* Added `add_dockerfile_heroku()` to create a Dockerfile from a DESCRIPTION, to be used with Heroku.

* `add_css_file()`, `add_js_file()` and `add_js_handler()` create a CSS, JS, and JS with Shiny custom handler files.

## Removed

* `use_utils_prod` is now included in golem so you don't have to explicitely include the functions.

## Docs 

* Golem now has four vignettes

# golem 0.0.1.0002

Last round of functions, and some documentation cleanup.

# golem 0.0.0.9000

* Moved from {shinytemplate} to {golem}

* Added a `NEWS.md` file to track changes to the package.
