> Notes: the # between parenthesis referes to the related issue on GitHub, and the @ refers to an external contributor solving this issue. 

# golem 0.1.9000+

## New functions

+ `add_fct` and `add_utils` add new files in your R folder that can hold utils and functions (#123).

+ We switched from `shiny::addResourcePath()` to `golem::add_resource_path()`, which doesn't fail if the folder is empty (#223).

+ New JavaScript functions to use alert, prompt and confirm (#108, @zwycl)

+ `add_external_js_file` and `add_external_css_file` are designed to download .js and .css file off the web to the appropriate directory (#130, @zwycl)

## New features

+ You can now create a golem without any comment (#171, @ArthurData)

+ The default `app_ui()` now has a `request` parameter, to natively handle bookmarking.

+ `document_and_reload()` now stops when it fails, and returns an explicit failure message (#157). It also uses `get_golem_wd()` as a default path, to be consistent with the rest of `{golem}` (#219, @j450h1)

+ `add_module` now allows to create and `fct_` and an `utils_` file (#154, @novica)

+ `golem::detach_all_attached()` is now silent (#186, @annakau)

+ There is now a series of addins for going to a specific golem file (#212, @novica), and also to wrap a selected text into `ns()` (#143, @kokbent)

+ Creation of a golem project is now a little bit more talkative (#63, @novica)

+ golem apps now have a title tag in the header by default, (#172,  @novica)

## Breaking changes 

+ `invoke_js()` now takes a list of elements to send to JS (through `...`) instead of a vector (#155, @zwycl)

## Bug fix

+ The Dockerfile is now correctly added to .Rbuildignore (#81)

+ The dockerfile for shinyproxy no longer has a typo (#156, @fmmattioni)

+ `normalizePath()` now has a correct winlash (@kokbent)

+ spellcheck in files (@privefl)

+ Message to link to `golem_add_external_resources()` is now conditional to R being in a golem project (#167, @novica)

+ Better error on missing name in add_*, (#120, @novica)

+ When adding file, the extension is now ignored if provided by the user (#231)

## Internal changes

+ We no longer depend on `{stringr}` (#201, @TomerPacific)

# golem 0.1.0 - CRAN release candidate,  v2

## New Functions 

+ `get_golem_wd` allows  to print the current golem working directory, and `set_golem_wd` to change it.

## Breaking changes 

+ In order to work, the functions creating files need a `golem.wd`. This working directory is set by `set_golem_options` or the first time you create a file. It default to `"."`, the current directory. 

+ Changes in the name of the args in `set_golem_options`: `pkg_path` is now `golem_wd`, `pkg_name` is now `golem_name`, `pkg_version` is now `golem_version`

## Internal changes

+ The `installed.packages()` function is no longer used.

# golem 0.0.1.9999 - CRAN release candidate

## Changes in the way run_app and deploy files are build

+ There is now a unique framework for run_app, that allows to deploy anywhere and can accept arguments. These arguments can then be retrieved with `get_golem_options()`. #

> See https://rtask.thinkr.fr/blog/shinyapp-runapp-shinyappdir-difference/

## Breaking Changes

+ There is no need for `ui.R` and `server.R` to exist by default. Removed. Can be recreated with `add_ui_server_files()`

## New function

+ There is now `add_shinyserver_file` & `add_shinyappsio_file`, #40
+ `add_ui_server_files()` creates an ui & server.R files.

## Small functions updates 

+ Functions that create file(s) now automatically create folder if it's not there. Can be prevented with `dir_create = FALSE`
+ Functions that create file(s) can now be prevented from opening with `open = FALSE`, #75
+ We have made explicit how to add external files (css & js) to the app, #78
+ Launch test is now included in the default tests #48

# golem 0.0.1.6000+

## Changes 

* `create_golem()` now switch to the newly created project
* `use_git()` is not listed in `dev/01_start.R`

## Breaking changes 

* Renamed `add_rconnect_file()` to `add_rstudioconnect_file()`
* Renamed `create_shiny_template()` to `create_golem()`
* Renamed `js()` to `activate_js()`
* Renamed `use_recommended_dep()` to `use_recommended_deps()`

## New functions 

* `invoke_js()` allows to call JS functions from the server side. #52

# golem 0.0.1.5000

## Changes 

* The dev files are now split in three - start / dev / deploy

* Every function that adds a file now check if the file already exists, and ask the user if they want to overwrite it (#15)

* Every module is now named mod_x_ui / mod_x_server, for consistency.

* You can now create package with "illegal" names, using the command line `golem::create_shiny_template()`. #18

* `add_browser_button()` is now named `browser_button()`, so that all the `add_*` function are only reserved for function adding files to the `golem`.

+ `add_*_files` now check if the folder exists, if not suggests to create it. #36

## New functions

* You now have a `browser_dev()` function that behaves like `warning_dev` and friends. #46

* Added `set_golem_options()` to add local options used internally by {golem} && added it to the `01_start.R`. #49

* Added `add_dockerfile()` to create a Dockerfile from a DESCRIPTION.

* Added `add_dockerfile_shinyproxy()` to create a Dockerfile from a DESCRIPTION, to be used in Shiny Proxy.

* Added `add_dockerfile_heroku()` to create a Dockerfile from a DESCRIPTION, to be used with Heroku.

* `add_css_file()`, `add_js_file()` and `add_js_handler()` create a CSS, JS, and JS with Shiny custom handler files.

## Removed

* `use_utils_prod` is now included in golem so you don't have to explicitly include the functions.

## Docs 

* Golem now has four vignettes

# golem 0.0.1.0002

Last round of functions, and some documentation cleanup.

# golem 0.0.0.9000

* Moved from {shinytemplate} to {golem}

* Added a `NEWS.md` file to track changes to the package.
