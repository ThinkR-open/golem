> Notes: the # between parenthesis referes to the related issue on GitHub, and the @ refers to an external contributor solving this issue. 

# golem 0.3.1

## New functions

### `add_*`

+ You can now create a skeleton for a Shiny input binding using the `golem::add_js_binding("name")` function (#452, @DivadNojnarg)

+ You can now create a skeleton for a Shiny output binding using the `golem::add_js_output_binding("name")` function (@DivadNojnarg)

+ `add_html_template()` creates an htmlTemplate.

### `use_*`

+ `use_external_file()` allows to add any file to the `www` folder, `use_external_css_file()`, `use_external_html_template()`, and `use_external_js_file()` will download them from a URL (#295, #491).

+ `use_internal_css_file()`, `use_internal_file()`, `use_internal_html_template()`, `use_internal_js_file()` functions allow to any file from the current computer to the `www` folder (@KasperThystrup, #529)

### Tests helper

+ `expect_running()` expects the current shiny app to be running.

### Hooks

+ Every `{golem}` project now have a `project_hook` that is launched after the project creation.

+ `module_template()` is the default function for `{golem}` module creation. Users will now be able to define a custom `module_template()` function for `add_module()`, allowing to extend `{golem}` with your own module creation function. See ?golem::module_template for more info (#365)

+ `add_js_` and `add_css_` functions now have a template function, allowing to pass a file constructor.

### Misc

+ `is_running()` checks if the current running application is a `{golem}` based application (#366)

+ `utils_ui.R` now contains a "make_action_button()" function (#457, @DivadNojnarg)

+ `run_dev()` launches the `run_dev.R` script (#478, @KoderKow)

+ `run_dev()` performs a check on golem name.

+ `sanity_check()` function has been added to check for any 'browser()' or commented  #TODO / #TOFIX / #BUG in the code (#1354 @Swechhya) 

## New features

+ The modules are now created with the new skeleton when the installed version of `{shiny}` is >= 1.5.0.

+ `use_external_*()` function don't open files by default (#404)

+ `use_recommended_tests*()` now calls ` use_spell_check()` (#430)

+ The `02_dev.R` now includes more CI links

+ `golem::expect_running()` is now bundled in default tests

+ Default tests now test for functions formals (#437)

+ You can now pass arguments to internal `roxygenise()` & `load_all()` (#467)

+ `Bundle_resources()` now handle subfolders (#446)

+ `run_app()` now includes the default arguments of `shinyApp()` (#254, @chasemc)

+ `create_golem()` now adds strict dependency versions (#466)

+ `{golem}` app now comes with a meta tags "app-builder", which default to "golem", and that can be changed or turn off in `bundle_resources()`.

+ `with_golem_options` can now explicit calls `print` on the `app` object, solving some issues with benchmarking the application. This explicit print can be turned off by setting `print` to FALSE in `with_golem_options` (#148)

+ `dockerignore` is now available.

+ The `add_helpers` and `add_utils` now have roxygen comments (Richard Pilbery, #330)

+ `dev/03_dev.R` now has `devtools::build()` (#603)

+ `detach_all_attached()` is now silent (#605)

## Soft deprecated

+ `add_ui_server_files()` is now signaled as deprecated. Please comment on https://github.com/ThinkR-open/golem/issues/445 if you want it to be kept inside the package

## Breaking changes

+ `add_dockerfile*` function now return the `{dockerfiler}` object instead of the path to it. It allows to modify the Dockerfile object programmatically. (#493) 

+ The `get_golem_config` now first look for a `GOLEM_CONFIG_ACTIVE` before looking for `R_CONFIG_ACTIVE` (#563)

## Bug fix

+ `add_` functions no longer append to file if it already exists (#393)

+ `config::get()` is no longer exported to prevent namespace conflicts with `base::get()`
 
+ fixed issue with favicon when package is built (#387)

+ `use_external_*()` function don't add ext if already there (#405)

+ `create_golem` function does not modify any existing file (#423, @antoine-sachet)

+ `add_resources_path()` now correctly handles empty folder (#395)

+ test for app launching is now skipped if not interactive()

+ `add_utils` and `add_fct` now print to the console (#427, @novica)

+ Multiple CRAN repo are now correctly passed to the Dockerfile (#462)

+ app_config, DESC and golem-config.yml are now updated whenever you change the name of the package using a golem function (#469 )

+ `test_recommended` now work in every case (hopefully)

- `usethis::use_mit_license` does not have the `name` argument anymore so if fits new version of `{usethis}` (#594)

- Typo fix preventing `invoke_js("prompt")` and `invoke_js("confirm")` to work (#606)

## Internal changes

+ `document_and_reload()` now has `export_all = FALSE,helpers = FALSE,attach_testthat = FALSE`, allowing the function to behave more closely to what library() does (#399)

+ Dockerfile generation now removes the copied file and tar.gz

# golem 0.2.1

## New functions

+ `add_dockerfile()` was completely refactored. It now starts from r-ver, uses explicit package versions from you local machine, and tries to set as much System Requirements as possible by using `{sysreq}`, and parses and installs the Remotes tag from the DESCRIPTION (#189, #175)

+ `add_dockerfile()` allow now to directly use the source of the package by mounting the source folder in the container and running `remotes::install_local()`

+ `add_dockerfile()` now builds the tar.gz (#273)

+ `add_fct` and `add_utils` add new files in your R folder that can hold utils and functions (#123).

+ We switched from `shiny::addResourcePath()` to `golem::add_resource_path()`, which doesn't fail if the folder is empty (#223).

+ New JavaScript functions to use alert, prompt and confirm (#108, @zwycl)

+ `use_external_js_file` and `use_external_css_file` are designed to download .js and .css file off the web to the appropriate directory (#130, @zwycl)


## New features

+ `{golem}` now comes with an internal config file. Please refer to the `config` Vignette for more information.

+ `bundle_resources()` comes with every new app and bundles all the css and js files you put inside the `inst/app/www` folder, by matchine the file extension.

+ There is now an `app_sys()` function, which is a wrapper around `system.file(..., package = "myapp")` (#207,  @novica)

+ `document_and_reload()` now stops when it fails, and returns an explicit failure message (#157)

+ You can now create a golem without any comment (#171, @ArthurData)

+ The default `app_ui()` now has a `request` parameter, to natively handle bookmarking.

+ `document_and_reload()` now stops when it fails, and returns an explicit failure message (#157). It also uses `get_golem_wd()` as a default path, to be consistent with the rest of `{golem}` (#219, @j450h1)

+ `add_module` now allows to create and `fct_` and an `utils_` file (#154, @novica)

+ `golem::detach_all_attached()` is now silent (#186, @annakau)

+ There is now a series of addins for going to a specific golem file (#212, @novica), and also to wrap a selected text into `ns()` (#143, @kokbent)

+ Creation of a golem project is now a little bit more talkative (#63, @novica)

+ golem apps now have a title tag in the header by default, (#172,  @novica)

+ The `rsconnect` folder is now added to `.Rbuildignore` (#244)

+ `devtools::test()` in 03_deploy.R is now `devtools::check()`

+ modules bow have a placeholder for content 

+ Dev scripts have been rewritten and rerordered a litte bit

## Breaking changes 

+ `invoke_js()` now takes a list of elements to send to JS (through `...`) instead of a vector (#155, @zwycl)

+ `get_dependencies` was removed from this package, please use `desc::desc_get_deps()` instead (#251)

+ `{golem}` now uses `here::here()` to determine the default working directory (#287)

+ Modules used to be exported by default. You now have to specify it when creating the modules (#144)

+ `run_app()` is no longer explicitely namespaced in the run_dev script (#267)

+ JavaScript files now default to having `$(document).ready()` (#227)

+ Every filesystem manipulation is now done with `{fs}`. That should be pretty transparent for most users but please open an issue if it causes problem (#285)

## Bug fix

+ The Dockerfile is now correctly added to .Rbuildignore (#81)

+ The dockerfile for shinyproxy no longer has a typo (#156, @fmmattioni)

+ `normalizePath()` now has a correct winlash (@kokbent)

+ spellcheck in files (@privefl)

+ Message to link to `golem_add_external_resources()` is now conditional to R being in a golem project (#167, @novica)

+ Better error on missing name in add_*, (#120, @novica)

+ When adding file, the extension is now ignored if provided by the user (#231)

+ The dots R/run_app.R are now documented by default (#243)

+ Bug fix of the pkgdown website (#180)

+ `{golem}` now correctly handles command line creation of projet inside the current directory (#248)

+ The test are now more robust when it comes to random name generation (#281)

## Internal changes

+ We no longer depend on `{stringr}` (#201, @TomerPacific)

+ get_golem_wd() is now used everywhere in `{golem}` (#237, @felixgolcher)

# golem 0.1.0 - CRAN release candidate,  v2

## New Functions 

+ `get_golem_wd` allows  to print the current golem working directory, and `set_golem_wd` to change it.

## Breaking changes 

+ In order to work, the functions creating files need a `golem.wd`. This working directory is set by `set_golem_options` or the first time you create a file. It default to `"."`, the current directory. 

+ Changes in the name of the args in `set_golem_options`: `pkg_path` is now `golem_wd`, `pkg_name` is now `golem_name`, `pkg_version` is now `golem_version`

## Internal changes

+ The `installed.packages()` function is no longer used.

+ Every filesystem manipulation is now done with `{fs}` (#285)

# golem 0.0.1.9999 - CRAN release candidate

## Changes in the way run_app and deploy files are build

+ There is now a unique framework for run_app, that allows to deploy anywhere and can accept arguments. These arguments can then be retrieved with `get_golem_options()`. 

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
