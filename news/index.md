# Changelog

## golem 0.5.1 to 0.6.0

CRAN release: 2024-08-27

### New features / user-visible changes

- The `add_dockerfile_with_renv_*` function now generates a multi-stage
  Dockerfile by default (use `single_file = FALSE` to retain the
  previous behavior).
- The `add_dockerfile_with_renv_*` function now creates a Dockerfile
  that sets `golem.app.prod = TRUE` by default (use
  `set_golem.app.prod = FALSE` to retain the previous behavior).

### Breaking change

- The
  [`get_current_config()`](https://thinkr-open.github.io/golem/reference/get_current_config.md)
  has been rework in two ways: (1) it nows either check the
  `GOLEM_CONFIG_PATH` env var or the default path
  (inst/golem-config.yml). [golem](https://thinkr-open.github.io/golem/)
  no longer tries to guess non standard paths, and does a hard fail if
  the file doesn’t exist, (2) the function no longer copy the `config`
  files from the skeleton if ever the files are not there
  ([@ilyaZar](https://github.com/ilyaZar),
  [@LDSamson](https://github.com/LDSamson),
  [\#1178](https://github.com/ThinkR-open/golem/issues/1178))

- [golem](https://thinkr-open.github.io/golem/) functions used to rely
  on arguments that where either `wd`, `path`, `pkg` or `golem_wd`. This
  has now been standardized and all functions rely on `golem_wd` now
  ([@ilyaZar](https://github.com/ilyaZar),
  [\#845](https://github.com/ThinkR-open/golem/issues/845))

- Creating a `golem` doesn’t call `set_here()` nor
  [`usethis::create_project()`](https://usethis.r-lib.org/reference/create_package.html)
  anymore. It used to be because we wanted to be able to use
  `here::here()`, but the function should be able to find its way based
  using `DESCRIPTION`. It gives a lighter implementation of golem
  projects creation as it doesn’t mess up with where `here()` is
  anymore.

- The `add_*_files` and `use_*_files` now fail when:

  - The directory where the user tries to add the file doesn’t exist.
    [golem](https://thinkr-open.github.io/golem/) used to try to create
    the directory but that’s not the function job — use\_\*\_file
    functions should only be there to add file (Singe responsabily )
  - The file that the user tries to create already exists

- Creating a golem with `create_golem(overwrite = TRUE)` will now
  **delete the old folder** and replace with the golem skeleton.

### User visible change

- [`run_dev()`](https://thinkr-open.github.io/golem/reference/run_dev.md)
  only prints one message
  ([\#1191](https://github.com/ThinkR-open/golem/issues/1191) /
  [@howardbaik](https://github.com/howardbaik))

### Bug fix

- Removing the comments on golem creation didn’t work fully, this has
  been fixed.

- Renamed a function in 02_dev.R (add_any_file =\> add_empty_file)

### Internal changes

- Full refactoring of the `add_*_files` and `use_*_files` functions that
  now all share the same behavior

- The internal `check_name_consistency()` now parses the code of
  `app_config.R` and get the `package` arg of `system.file`, instead of
  doing a text based search. This allows the function to detect several
  calls to `system.file` and fixes the bug from
  [\#1179](https://github.com/ThinkR-open/golem/issues/1179)

### Doc

- Vignettes have been renamed

## golem 0.5.1

CRAN release: 2024-08-27

- Hotfixing a bug with utils_download_file
  ([\#1168](https://github.com/ThinkR-open/golem/issues/1168))

## golem 0.5.0

CRAN release: 2024-08-19

### New functions

- [`is_golem()`](https://thinkr-open.github.io/golem/reference/is_golem.md)
  tries to guess if the current folder is a
  [golem](https://thinkr-open.github.io/golem/)-based app
  ([\#836](https://github.com/ThinkR-open/golem/issues/836))

- [`use_readme_rmd()`](https://thinkr-open.github.io/golem/reference/use_readme_rmd.md)
  adds a [golem](https://thinkr-open.github.io/golem/) specific
  `README.Rmd` ([@ilyaZar](https://github.com/ilyaZar),
  [\#1011](https://github.com/ThinkR-open/golem/issues/1011))

- rename
  [`add_rstudioconnect_file()`](https://thinkr-open.github.io/golem/reference/rstudio_deploy.md)
  to
  [`add_positconnect_file()`](https://thinkr-open.github.io/golem/reference/rstudio_deploy.md)
  ([@ilyaZar](https://github.com/ilyaZar),
  [\#1017](https://github.com/ThinkR-open/golem/issues/1017))

- `add_empty_file` creates an empty file in the www directory
  ([\#837](https://github.com/ThinkR-open/golem/issues/837))

- [`add_r6()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
  adds an empty R6 file ([@ilyaZar](https://github.com/ilyaZar),
  [\#1009](https://github.com/ThinkR-open/golem/issues/1009))

- `golem::welcome_page()` now display a page on default scaffold app
  ([\#1126](https://github.com/ThinkR-open/golem/issues/1126))

- Defunct usethis functions has been removed from dev.R
  ([@ilyaZar](https://github.com/ilyaZar),
  [\#1125](https://github.com/ThinkR-open/golem/issues/1125))

### New features / user visible changes

- sourcing `dev/01_start.R` leaves the file in a clean state with all
  files added to the initial commit
  ([\#1094](https://github.com/ThinkR-open/golem/issues/1094),
  [@ilyaZar](https://github.com/ilyaZar))

- allow for user supplied `run_dev`-files
  ([\#886](https://github.com/ThinkR-open/golem/issues/886),
  [@ilyaZar](https://github.com/ilyaZar))

- `README` is re-styled and links to various external resources of the
  `golemverse`
  ([\#1064](https://github.com/ThinkR-open/golem/issues/1064),
  [@ilyaZar](https://github.com/ilyaZar))

- `a_start`-vignette has updated documentation
  ([\#1046](https://github.com/ThinkR-open/golem/issues/1046),
  [@ilyaZar](https://github.com/ilyaZar))

- [`fill_desc()`](https://thinkr-open.github.io/golem/reference/fill_desc.md)
  automatically calls `set_options()`; see `dev/01_start.R` as well
  ([\#1040](https://github.com/ThinkR-open/golem/issues/1040),
  [@ilyaZar](https://github.com/ilyaZar))

- [`fill_desc()`](https://thinkr-open.github.io/golem/reference/fill_desc.md)
  now uses a `person` vector
  ([\#1027](https://github.com/ThinkR-open/golem/issues/1027),
  [@jmeyer2482](https://github.com/jmeyer2482),
  [@ColinFay](https://github.com/ColinFay) and
  [@ilyaZar](https://github.com/ilyaZar))

- `use_{internal,external}_XXX_file()` function family has improved
  error handling for non-interactive usage
  ([\#1062](https://github.com/ThinkR-open/golem/issues/1062),
  [@ilyaZar](https://github.com/ilyaZar))

- [`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
  now adds the skeleton for a function
  ([\#1004](https://github.com/ThinkR-open/golem/issues/1004),
  [@ilyaZar](https://github.com/ilyaZar))

- The module skeleton now stick to tidyverse style
  ([\#1019](https://github.com/ThinkR-open/golem/issues/1019),
  [@ni2scmn](https://github.com/ni2scmn))

- Better comments to
  [`fill_desc()`](https://thinkr-open.github.io/golem/reference/fill_desc.md)
  in `01_start.R`
  ([\#1021](https://github.com/ThinkR-open/golem/issues/1021),
  [@ilyaZar](https://github.com/ilyaZar))

- `01_start.R` now has a call to
  [`usethis::use_git_remote()`](https://usethis.r-lib.org/reference/use_git_remote.html)
  ([\#1015](https://github.com/ThinkR-open/golem/issues/1015),
  [@ilyaZar](https://github.com/ilyaZar))

- Tests for `R/golem_utils_server.R` and `R/golem_utils_ui.R` now have
  full code coverage
  ([\#1020](https://github.com/ThinkR-open/golem/issues/1020),
  [@ilyaZar](https://github.com/ilyaZar))

- When setting a new name, [golem](https://thinkr-open.github.io/golem/)
  now browses tests & vignettes
  ([\#805](https://github.com/ThinkR-open/golem/issues/805),
  [@ilyaZar](https://github.com/ilyaZar))

- Adding `writeManifest()` to `deploy.R`
  ([\#1063](https://github.com/ThinkR-open/golem/issues/1063),
  [@ilyaZar](https://github.com/ilyaZar))

- `use_git()` is now at the bottom of 01_dev.R
  (([\#1094](https://github.com/ThinkR-open/golem/issues/1094),
  [@ilyaZar](https://github.com/ilyaZar)))

- `golem::add_dockerfile_with_renv_*()` set “rstudio” as default USER in
  Dockerfile to avoid launching app as root

- It is now easier to modify the renv.config.pak.enabled parameter in
  the Dockerfile generated by `golem::add_dockerfile_with_renv_*()`
  functions.

- We create an `.rscignore` in the golem dir whenever creating the
  connect related file
  ([\#110](https://github.com/ThinkR-open/golem/issues/110),
  [@ilyaZar](https://github.com/ilyaZar))

### Bug fixes

- `use_{internal,external}_XXX_file()` function family works with
  default missing `name` argument
  ([\#1060](https://github.com/ThinkR-open/golem/issues/1060),
  [@ilyaZar](https://github.com/ilyaZar))

- [`run_dev()`](https://thinkr-open.github.io/golem/reference/run_dev.md)
  now install needed dependencies to source `dev/run_dev.R` if needed
  ([\#942](https://github.com/ThinkR-open/golem/issues/942),
  [@ilyaZar](https://github.com/ilyaZar),
  [@vincentGuyader](https://github.com/vincentGuyader))

- [`use_readme_rmd()`](https://thinkr-open.github.io/golem/reference/use_readme_rmd.md)
  does not pop up when argument `open=FALSE` is set
  ([\#1044](https://github.com/ThinkR-open/golem/issues/1044),
  [@ilyaZar](https://github.com/ilyaZar))

- Docker commands now take the `-it` flag so it can be killed with `^C`
  ([\#1002](https://github.com/ThinkR-open/golem/issues/1002),
  [@ivokwee](https://github.com/ivokwee))

- [`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md)
  now behaves correctly when trying to use `mod_mod_XXX` and no longer
  opens an interactive menu
  ([\#997](https://github.com/ThinkR-open/golem/issues/997),
  [@ilyaZar](https://github.com/ilyaZar))

- [attachment](https://thinkr-open.github.io/attachment/) now has a
  minimum version requirement
  ([\#1104](https://github.com/ThinkR-open/golem/issues/1104),
  [@ilyaZar](https://github.com/ilyaZar))

- [pkgload](https://github.com/r-lib/pkgload) now has a minimum version
  requirement
  ([\#1106](https://github.com/ThinkR-open/golem/issues/1106))

- [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
  can be now used with path = “.” and package_name empty

### Internal changes

- Add tests for (under/un)-tested files and functions and improve code
  coverage of [golem](https://thinkr-open.github.io/golem/)
  ([\#1043](https://github.com/ThinkR-open/golem/issues/1043),
  [\#1050](https://github.com/ThinkR-open/golem/issues/1050),
  [\#1059](https://github.com/ThinkR-open/golem/issues/1059),
  [\#1066](https://github.com/ThinkR-open/golem/issues/1066),
  [\#1075](https://github.com/ThinkR-open/golem/issues/1075),
  [@ilyaZar](https://github.com/ilyaZar))

- `guess_where_config()` now finds the user config-yaml by reading its
  new location from user changes in “R/app_config.R”
  ([\#887](https://github.com/ThinkR-open/golem/issues/887),
  [@ilyaZar](https://github.com/ilyaZar))

- All functions that require to get a path now rely on
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md)
  ([\#1016](https://github.com/ThinkR-open/golem/issues/1016),
  [@ilyaZar](https://github.com/ilyaZar))

- The test suite has been refactored and is now silent and faster.

## golem 0.3.5

CRAN release: 2022-10-18

Update in the tests for CRAN (commented a test that made new version of
testthat fail).

## golem 0.3.4

CRAN release: 2022-09-26

Update in the tests for CRAN (skip not installed + examples).

## golem 0.3.3

CRAN release: 2022-07-13

### New functions

- [`add_dockerfile_with_renv()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md),
  [`add_dockerfile_with_renv_heroku()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  and
  [`add_dockerfile_with_renv_shinyproxy()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  build Dockerfiles that rely on [renv](https://rstudio.github.io/renv/)

#### Soft deprecated

- `add_dockerfile`,
  [`add_dockerfile_shinyproxy()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  and
  [`add_dockerfile_heroku()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  now recommend to switch to their `_with_renv_` counterpart

## golem 0.3.2

CRAN release: 2022-03-04

#### Soft deprecated

- [`use_recommended_deps()`](https://thinkr-open.github.io/golem/reference/use_recommended.md)
  is now soft deprecated
  ([\#786](https://github.com/ThinkR-open/golem/issues/786))

#### Hard deprecated

- The `html` parameter in
  [`expect_html_equal()`](https://thinkr-open.github.io/golem/reference/testhelpers.md)
  is no longer in use
  ([\#55](https://github.com/ThinkR-open/golem/issues/55)).

### New functions

- [`add_sass_file()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  creates a .sass file in inst/app/www
  ([\#768](https://github.com/ThinkR-open/golem/issues/768))

- [`use_module_test()`](https://thinkr-open.github.io/golem/reference/use_module_test.md)
  creates a test skeleton for a module
  ([\#725](https://github.com/ThinkR-open/golem/issues/725))

### New features

- The `02_dev.R` file now suggests using
  [`attachment::att_amend_desc()`](https://thinkr-open.github.io/attachment/reference/att_amend_desc.html)
  ([\#787](https://github.com/ThinkR-open/golem/issues/787))

- `use_code_of_conduct()` in dev script now has the contact param
  ([\#812](https://github.com/ThinkR-open/golem/issues/812))

- All `with_test` params are now TRUE in the dev script
  ([\#801](https://github.com/ThinkR-open/golem/issues/801))

- `test-golem-recommended` now has two new tests for `app_sys` and
  `get_golem_config`
  ([\#751](https://github.com/ThinkR-open/golem/issues/751))

- [`use_utils_ui()`](https://thinkr-open.github.io/golem/reference/utils_files.md)
  [`use_utils_server()`](https://thinkr-open.github.io/golem/reference/utils_files.md)
  & now come with a `with_test` parameter that adds a test file for
  theses functions
  ([\#625](https://github.com/ThinkR-open/golem/issues/625) &
  [\#801](https://github.com/ThinkR-open/golem/issues/801))

- [golem](https://thinkr-open.github.io/golem/) now checks if a module
  exists before adding a module related file
  ([\#779](https://github.com/ThinkR-open/golem/issues/779))

- Every [rstudioapi](https://rstudio.github.io/rstudioapi/) calls is now
  conditionned by the availabily of this function
  ([\#776](https://github.com/ThinkR-open/golem/issues/776))

- `use_external_*` functions no longer suggest to “Go to”
  ([\#713](https://github.com/ThinkR-open/golem/issues/713),
  [@novica](https://github.com/novica))

- [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
  now comes with `with_git` parameter that can be used to initialize git
  repository while creating a project template

- [`use_recommended_tests()`](https://thinkr-open.github.io/golem/reference/use_recommended.md)
  now comes with `testServer`
  ([\#720](https://github.com/ThinkR-open/golem/issues/720)).

- [`expect_html_equal()`](https://thinkr-open.github.io/golem/reference/testhelpers.md)
  now uses
  [`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html)
  ([\#55](https://github.com/ThinkR-open/golem/issues/55)).

- `add_modules()`,
  [`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
  and
  [`add_utils()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
  now come with a `with_test` parameter that can be turned on to add a
  test file to the module
  ([\#719](https://github.com/ThinkR-open/golem/issues/719) &
  [\#141](https://github.com/ThinkR-open/golem/issues/141))

- /! All docker related functions have been moved to
  [dockerfiler](https://thinkr-open.github.io/dockerfiler/). This is
  more or less a breaking change, cause you’ll need to install
  [dockerfiler](https://thinkr-open.github.io/dockerfiler/) \> 0.1.4 in
  order to build the Dockerfile **but**
  [golem](https://thinkr-open.github.io/golem/) will ask you to install
  [dockerfiler](https://thinkr-open.github.io/dockerfiler/) \> 0.1.4 if
  it can’t find it,
  ([\#412](https://github.com/ThinkR-open/golem/issues/412))

- Modules ID no longer contain an `_ui_` element,
  ([\#651](https://github.com/ThinkR-open/golem/issues/651),
  [@MargotBr](https://github.com/MargotBr))

- run_dev now has `options(shiny.port = httpuv::randomPort())` to
  prevent the browser from caching the CSS & JS files
  ([\#675](https://github.com/ThinkR-open/golem/issues/675))

- You can now specify the path to R in
  [`expect_running()`](https://thinkr-open.github.io/golem/reference/testhelpers.md).

### Bug fix

- Fixed a bug in the printing of the htmlTemplate code
  ([\#827](https://github.com/ThinkR-open/golem/issues/827))

- We now require the correct [usethis](https://usethis.r-lib.org)
  version (822)

- `golem::amend_config()` now keeps the `!expr`
  ([\#709](https://github.com/ThinkR-open/golem/issues/709),
  [@teofiln](https://github.com/teofiln))

- recommended tests now use `expect_type()` instead of `expect_is`,
  which was deprecated from [testthat](https://testthat.r-lib.org)
  ([\#671](https://github.com/ThinkR-open/golem/issues/671))

- Fixed check warning when using
  [`golem::use_utils_server()`](https://thinkr-open.github.io/golem/reference/utils_files.md)
  ([\#678](https://github.com/ThinkR-open/golem/issues/678)),

- Fixed issue with expect_running & path to R
  ([\#700](https://github.com/ThinkR-open/golem/issues/700),
  [@waiteb5](https://github.com/waiteb5))

- [`expect_running()`](https://thinkr-open.github.io/golem/reference/testhelpers.md)
  now find R.exe on windows.

- [`use_recommended_tests()`](https://thinkr-open.github.io/golem/reference/use_recommended.md)
  no longer add [processx](https://processx.r-lib.org) to the
  `DESCRIPTION`
  ([\#710](https://github.com/ThinkR-open/golem/issues/710))

- `bundle_resource()` does not include empty stylesheet anymore
  ([\#689](https://github.com/ThinkR-open/golem/issues/689),
  [@erikvona](https://github.com/erikvona))

### Internal changes

- Create [golem](https://thinkr-open.github.io/golem/) is more robust
  and now comes with an `overwrite` argument
  ([\#777](https://github.com/ThinkR-open/golem/issues/777))

- [testthat](https://testthat.r-lib.org) and
  [rlang](https://rlang.r-lib.org) are no longer hard dependencies
  ([\#742](https://github.com/ThinkR-open/golem/issues/742))

## golem 0.3.1

CRAN release: 2021-04-17

### New functions

#### `add_*`

- You can now create a skeleton for a Shiny input binding using the
  `golem::add_js_binding("name")` function
  ([\#452](https://github.com/ThinkR-open/golem/issues/452),
  [@DivadNojnarg](https://github.com/DivadNojnarg))

- You can now create a skeleton for a Shiny output binding using the
  `golem::add_js_output_binding("name")` function
  ([@DivadNojnarg](https://github.com/DivadNojnarg))

- [`add_html_template()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  creates an htmlTemplate.

#### `use_*`

- [`use_external_file()`](https://thinkr-open.github.io/golem/reference/use_files.md)
  allows to add any file to the `www` folder,
  [`use_external_css_file()`](https://thinkr-open.github.io/golem/reference/use_files.md),
  [`use_external_html_template()`](https://thinkr-open.github.io/golem/reference/use_files.md),
  and
  [`use_external_js_file()`](https://thinkr-open.github.io/golem/reference/use_files.md)
  will download them from a URL
  ([\#295](https://github.com/ThinkR-open/golem/issues/295),
  [\#491](https://github.com/ThinkR-open/golem/issues/491)).

- [`use_internal_css_file()`](https://thinkr-open.github.io/golem/reference/use_files.md),
  [`use_internal_file()`](https://thinkr-open.github.io/golem/reference/use_files.md),
  [`use_internal_html_template()`](https://thinkr-open.github.io/golem/reference/use_files.md),
  [`use_internal_js_file()`](https://thinkr-open.github.io/golem/reference/use_files.md)
  functions allow to any file from the current computer to the `www`
  folder ([@KasperThystrup](https://github.com/KasperThystrup),
  [\#529](https://github.com/ThinkR-open/golem/issues/529))

#### Tests helper

- [`expect_running()`](https://thinkr-open.github.io/golem/reference/testhelpers.md)
  expects the current shiny app to be running.

#### Hooks

- Every [golem](https://thinkr-open.github.io/golem/) project now have a
  `project_hook` that is launched after the project creation.

- [`module_template()`](https://thinkr-open.github.io/golem/reference/module_template.md)
  is the default function for
  [golem](https://thinkr-open.github.io/golem/) module creation. Users
  will now be able to define a custom
  [`module_template()`](https://thinkr-open.github.io/golem/reference/module_template.md)
  function for
  [`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md),
  allowing to extend [golem](https://thinkr-open.github.io/golem/) with
  your own module creation function. See ?golem::module_template for
  more info ([\#365](https://github.com/ThinkR-open/golem/issues/365))

- `add_js_` and `add_css_` functions now have a template function,
  allowing to pass a file constructor.

#### Misc

- [`is_running()`](https://thinkr-open.github.io/golem/reference/is_running.md)
  checks if the current running application is a
  [golem](https://thinkr-open.github.io/golem/) based application
  ([\#366](https://github.com/ThinkR-open/golem/issues/366))

- `utils_ui.R` now contains a “make_action_button()” function
  ([\#457](https://github.com/ThinkR-open/golem/issues/457),
  [@DivadNojnarg](https://github.com/DivadNojnarg))

- [`run_dev()`](https://thinkr-open.github.io/golem/reference/run_dev.md)
  launches the `run_dev.R` script
  ([\#478](https://github.com/ThinkR-open/golem/issues/478),
  [@KoderKow](https://github.com/KoderKow))

- [`run_dev()`](https://thinkr-open.github.io/golem/reference/run_dev.md)
  performs a check on golem name.

- [`sanity_check()`](https://thinkr-open.github.io/golem/reference/sanity_check.md)
  function has been added to check for any ‘browser()’ or commented
  \#TODO / \#TOFIX / \#BUG in the code
  ([\#1354](https://github.com/ThinkR-open/golem/issues/1354)
  [@Swechhya](https://github.com/Swechhya))

### New features

- The modules are now created with the new skeleton when the installed
  version of [shiny](https://shiny.posit.co/) is \>= 1.5.0.

- `use_external_*()` function don’t open files by default
  ([\#404](https://github.com/ThinkR-open/golem/issues/404))

- `use_recommended_tests*()` now calls `use_spell_check()`
  ([\#430](https://github.com/ThinkR-open/golem/issues/430))

- The `02_dev.R` now includes more CI links

- [`golem::expect_running()`](https://thinkr-open.github.io/golem/reference/testhelpers.md)
  is now bundled in default tests

- Default tests now test for functions formals
  ([\#437](https://github.com/ThinkR-open/golem/issues/437))

- You can now pass arguments to internal `roxygenise()` & `load_all()`
  ([\#467](https://github.com/ThinkR-open/golem/issues/467))

- `Bundle_resources()` now handle subfolders
  ([\#446](https://github.com/ThinkR-open/golem/issues/446))

- `run_app()` now includes the default arguments of
  [`shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
  ([\#254](https://github.com/ThinkR-open/golem/issues/254),
  [@chasemc](https://github.com/chasemc))

- [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
  now adds strict dependency versions
  ([\#466](https://github.com/ThinkR-open/golem/issues/466))

- [golem](https://thinkr-open.github.io/golem/) app now comes with a
  meta tags “app-builder”, which default to “golem”, and that can be
  changed or turn off in
  [`bundle_resources()`](https://thinkr-open.github.io/golem/reference/bundle_resources.md).

- `with_golem_options` can now explicit calls `print` on the `app`
  object, solving some issues with benchmarking the application. This
  explicit print can be turned off by setting `print` to FALSE in
  `with_golem_options`
  ([\#148](https://github.com/ThinkR-open/golem/issues/148))

- `dockerignore` is now available.

- The `add_helpers` and `add_utils` now have roxygen comments (Richard
  Pilbery, [\#330](https://github.com/ThinkR-open/golem/issues/330))

- `dev/03_dev.R` now has
  [`devtools::build()`](https://devtools.r-lib.org/reference/build.html)
  ([\#603](https://github.com/ThinkR-open/golem/issues/603))

- [`detach_all_attached()`](https://thinkr-open.github.io/golem/reference/detach_all_attached.md)
  is now silent
  ([\#605](https://github.com/ThinkR-open/golem/issues/605))

### Soft deprecated

- [`add_ui_server_files()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  is now signaled as deprecated. Please comment on
  <https://github.com/ThinkR-open/golem/issues/445> if you want it to be
  kept inside the package

### Breaking changes

- `add_dockerfile*` function now return the
  [dockerfiler](https://thinkr-open.github.io/dockerfiler/) object
  instead of the path to it. It allows to modify the Dockerfile object
  programmatically.
  ([\#493](https://github.com/ThinkR-open/golem/issues/493))

- The `get_golem_config` now first look for a `GOLEM_CONFIG_ACTIVE`
  before looking for `R_CONFIG_ACTIVE`
  ([\#563](https://github.com/ThinkR-open/golem/issues/563))

### Bug fix

- `add_` functions no longer append to file if it already exists
  ([\#393](https://github.com/ThinkR-open/golem/issues/393))

- [`config::get()`](https://rstudio.github.io/config/reference/get.html)
  is no longer exported to prevent namespace conflicts with
  [`base::get()`](https://rdrr.io/r/base/get.html)

- fixed issue with favicon when package is built
  ([\#387](https://github.com/ThinkR-open/golem/issues/387))

- `use_external_*()` function don’t add ext if already there
  ([\#405](https://github.com/ThinkR-open/golem/issues/405))

- `create_golem` function does not modify any existing file
  ([\#423](https://github.com/ThinkR-open/golem/issues/423),
  [@antoine-sachet](https://github.com/antoine-sachet))

- `add_resources_path()` now correctly handles empty folder
  ([\#395](https://github.com/ThinkR-open/golem/issues/395))

- test for app launching is now skipped if not interactive()

- `add_utils` and `add_fct` now print to the console
  ([\#427](https://github.com/ThinkR-open/golem/issues/427),
  [@novica](https://github.com/novica))

- Multiple CRAN repo are now correctly passed to the Dockerfile
  ([\#462](https://github.com/ThinkR-open/golem/issues/462))

- app_config, DESC and golem-config.yml are now updated whenever you
  change the name of the package using a golem function
  ([\#469](https://github.com/ThinkR-open/golem/issues/469) )

- `test_recommended` now work in every case (hopefully)

- [`usethis::use_mit_license`](https://usethis.r-lib.org/reference/licenses.html)
  does not have the `name` argument anymore so if fits new version of
  [usethis](https://usethis.r-lib.org)
  ([\#594](https://github.com/ThinkR-open/golem/issues/594))

- Typo fix preventing `invoke_js("prompt")` and `invoke_js("confirm")`
  to work ([\#606](https://github.com/ThinkR-open/golem/issues/606))

### Internal changes

- [`document_and_reload()`](https://thinkr-open.github.io/golem/reference/document_and_reload.md)
  now has `export_all = FALSE,helpers = FALSE,attach_testthat = FALSE`,
  allowing the function to behave more closely to what library() does
  ([\#399](https://github.com/ThinkR-open/golem/issues/399))

- Dockerfile generation now removes the copied file and tar.gz

## golem 0.2.1

CRAN release: 2020-03-05

### New functions

- [`add_dockerfile()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  was completely refactored. It now starts from r-ver, uses explicit
  package versions from you local machine, and tries to set as much
  System Requirements as possible by using `{sysreq}`, and parses and
  installs the Remotes tag from the DESCRIPTION
  ([\#189](https://github.com/ThinkR-open/golem/issues/189),
  [\#175](https://github.com/ThinkR-open/golem/issues/175))

- [`add_dockerfile()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  allow now to directly use the source of the package by mounting the
  source folder in the container and running
  [`remotes::install_local()`](https://remotes.r-lib.org/reference/install_local.html)

- [`add_dockerfile()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  now builds the tar.gz
  ([\#273](https://github.com/ThinkR-open/golem/issues/273))

- `add_fct` and `add_utils` add new files in your R folder that can hold
  utils and functions
  ([\#123](https://github.com/ThinkR-open/golem/issues/123)).

- We switched from
  [`shiny::addResourcePath()`](https://rdrr.io/pkg/shiny/man/resourcePaths.html)
  to
  [`golem::add_resource_path()`](https://thinkr-open.github.io/golem/reference/add_resource_path.md),
  which doesn’t fail if the folder is empty
  ([\#223](https://github.com/ThinkR-open/golem/issues/223)).

- New JavaScript functions to use alert, prompt and confirm
  ([\#108](https://github.com/ThinkR-open/golem/issues/108),
  [@zwycl](https://github.com/zwycl))

- `use_external_js_file` and `use_external_css_file` are designed to
  download .js and .css file off the web to the appropriate directory
  ([\#130](https://github.com/ThinkR-open/golem/issues/130),
  [@zwycl](https://github.com/zwycl))

### New features

- [golem](https://thinkr-open.github.io/golem/) now comes with an
  internal config file. Please refer to the `config` Vignette for more
  information.

- [`bundle_resources()`](https://thinkr-open.github.io/golem/reference/bundle_resources.md)
  comes with every new app and bundles all the css and js files you put
  inside the `inst/app/www` folder, by matchine the file extension.

- There is now an `app_sys()` function, which is a wrapper around
  `system.file(..., package = "myapp")`
  ([\#207](https://github.com/ThinkR-open/golem/issues/207),
  [@novica](https://github.com/novica))

- [`document_and_reload()`](https://thinkr-open.github.io/golem/reference/document_and_reload.md)
  now stops when it fails, and returns an explicit failure message
  ([\#157](https://github.com/ThinkR-open/golem/issues/157))

- You can now create a golem without any comment
  ([\#171](https://github.com/ThinkR-open/golem/issues/171),
  [@ArthurData](https://github.com/ArthurData))

- The default `app_ui()` now has a `request` parameter, to natively
  handle bookmarking.

- [`document_and_reload()`](https://thinkr-open.github.io/golem/reference/document_and_reload.md)
  now stops when it fails, and returns an explicit failure message
  ([\#157](https://github.com/ThinkR-open/golem/issues/157)). It also
  uses
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md)
  as a default path, to be consistent with the rest of
  [golem](https://thinkr-open.github.io/golem/)
  ([\#219](https://github.com/ThinkR-open/golem/issues/219),
  [@j450h1](https://github.com/j450h1))

- `add_module` now allows to create and `fct_` and an `utils_` file
  ([\#154](https://github.com/ThinkR-open/golem/issues/154),
  [@novica](https://github.com/novica))

- [`golem::detach_all_attached()`](https://thinkr-open.github.io/golem/reference/detach_all_attached.md)
  is now silent
  ([\#186](https://github.com/ThinkR-open/golem/issues/186),
  [@annakau](https://github.com/annakau))

- There is now a series of addins for going to a specific golem file
  ([\#212](https://github.com/ThinkR-open/golem/issues/212),
  [@novica](https://github.com/novica)), and also to wrap a selected
  text into `ns()`
  ([\#143](https://github.com/ThinkR-open/golem/issues/143),
  [@kokbent](https://github.com/kokbent))

- Creation of a golem project is now a little bit more talkative
  ([\#63](https://github.com/ThinkR-open/golem/issues/63),
  [@novica](https://github.com/novica))

- golem apps now have a title tag in the header by default,
  ([\#172](https://github.com/ThinkR-open/golem/issues/172),
  [@novica](https://github.com/novica))

- The `rsconnect` folder is now added to `.Rbuildignore`
  ([\#244](https://github.com/ThinkR-open/golem/issues/244))

- [`devtools::test()`](https://devtools.r-lib.org/reference/test.html)
  in 03_deploy.R is now
  [`devtools::check()`](https://devtools.r-lib.org/reference/check.html)

- modules bow have a placeholder for content

- Dev scripts have been rewritten and reordered a little bit

### Breaking changes

- [`invoke_js()`](https://thinkr-open.github.io/golem/reference/golem_js.md)
  now takes a list of elements to send to JS (through `...`) instead of
  a vector ([\#155](https://github.com/ThinkR-open/golem/issues/155),
  [@zwycl](https://github.com/zwycl))

- `get_dependencies` was removed from this package, please use
  [`desc::desc_get_deps()`](https://desc.r-lib.org/reference/desc_get_deps.html)
  instead ([\#251](https://github.com/ThinkR-open/golem/issues/251))

- [golem](https://thinkr-open.github.io/golem/) now uses `here::here()`
  to determine the default working directory
  ([\#287](https://github.com/ThinkR-open/golem/issues/287))

- Modules used to be exported by default. You now have to specify it
  when creating the modules
  ([\#144](https://github.com/ThinkR-open/golem/issues/144))

- `run_app()` is no longer explicitely namespaced in the run_dev script
  ([\#267](https://github.com/ThinkR-open/golem/issues/267))

- JavaScript files now default to having `$(document).ready()`
  ([\#227](https://github.com/ThinkR-open/golem/issues/227))

- Every filesystem manipulation is now done with
  [fs](https://fs.r-lib.org). That should be pretty transparent for most
  users but please open an issue if it causes problem
  ([\#285](https://github.com/ThinkR-open/golem/issues/285))

### Bug fix

- The Dockerfile is now correctly added to .Rbuildignore
  ([\#81](https://github.com/ThinkR-open/golem/issues/81))

- The dockerfile for shinyproxy no longer has a typo
  ([\#156](https://github.com/ThinkR-open/golem/issues/156),
  [@fmmattioni](https://github.com/fmmattioni))

- [`normalizePath()`](https://rdrr.io/r/base/normalizePath.html) now has
  a correct winlash ([@kokbent](https://github.com/kokbent))

- spellcheck in files ([@privefl](https://github.com/privefl))

- Message to link to `golem_add_external_resources()` is now conditional
  to R being in a golem project
  ([\#167](https://github.com/ThinkR-open/golem/issues/167),
  [@novica](https://github.com/novica))

- Better error on missing name in add\_\*,
  ([\#120](https://github.com/ThinkR-open/golem/issues/120),
  [@novica](https://github.com/novica))

- When adding file, the extension is now ignored if provided by the user
  ([\#231](https://github.com/ThinkR-open/golem/issues/231))

- The dots R/run_app.R are now documented by default
  ([\#243](https://github.com/ThinkR-open/golem/issues/243))

- Bug fix of the pkgdown website
  ([\#180](https://github.com/ThinkR-open/golem/issues/180))

- [golem](https://thinkr-open.github.io/golem/) now correctly handles
  command line creation of projet inside the current directory
  ([\#248](https://github.com/ThinkR-open/golem/issues/248))

- The test are now more robust when it comes to random name generation
  ([\#281](https://github.com/ThinkR-open/golem/issues/281))

### Internal changes

- We no longer depend on [stringr](https://stringr.tidyverse.org)
  ([\#201](https://github.com/ThinkR-open/golem/issues/201),
  [@TomerPacific](https://github.com/TomerPacific))

- get_golem_wd() is now used everywhere in
  [golem](https://thinkr-open.github.io/golem/)
  ([\#237](https://github.com/ThinkR-open/golem/issues/237),
  [@felixgolcher](https://github.com/felixgolcher))

## golem 0.1.0 - CRAN release candidate, v2

### New Functions

- `get_golem_wd` allows to print the current golem working directory,
  and `set_golem_wd` to change it.

### Breaking changes

- In order to work, the functions creating files need a `golem.wd`. This
  working directory is set by `set_golem_options` or the first time you
  create a file. It default to `"."`, the current directory.

- Changes in the name of the args in `set_golem_options`: `pkg_path` is
  now `golem_wd`, `pkg_name` is now `golem_name`, `pkg_version` is now
  `golem_version`

### Internal changes

- The
  [`installed.packages()`](https://rdrr.io/r/utils/installed.packages.html)
  function is no longer used.

- Every filesystem manipulation is now done with
  [fs](https://fs.r-lib.org)
  ([\#285](https://github.com/ThinkR-open/golem/issues/285))

## golem 0.0.1.9999 - CRAN release candidate

### Changes in the way run_app and deploy files are build

- There is now a unique framework for run_app, that allows to deploy
  anywhere and can accept arguments. These arguments can then be
  retrieved with
  [`get_golem_options()`](https://thinkr-open.github.io/golem/reference/get_golem_options.md).

> See
> <https://rtask.thinkr.fr/blog/shinyapp-runapp-shinyappdir-difference/>

### Breaking Changes

- There is no need for `ui.R` and `server.R` to exist by default.
  Removed. Can be recreated with
  [`add_ui_server_files()`](https://thinkr-open.github.io/golem/reference/add_files.md)

### New function

- There is now `add_shinyserver_file` & `add_shinyappsio_file`,
  [\#40](https://github.com/ThinkR-open/golem/issues/40)
- [`add_ui_server_files()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  creates an ui & server.R files.

### Small functions updates

- Functions that create file(s) now automatically create folder if it’s
  not there. Can be prevented with `dir_create = FALSE`
- Functions that create file(s) can now be prevented from opening with
  `open = FALSE`, [\#75](https://github.com/ThinkR-open/golem/issues/75)
- We have made explicit how to add external files (css & js) to the app,
  [\#78](https://github.com/ThinkR-open/golem/issues/78)
- Launch test is now included in the default tests
  [\#48](https://github.com/ThinkR-open/golem/issues/48)

## golem 0.0.1.6000+

### Changes

- [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
  now switch to the newly created project
- `use_git()` is not listed in `dev/01_start.R`

### Breaking changes

- Renamed
  [`add_rconnect_file()`](https://thinkr-open.github.io/golem/reference/rstudio_deploy.md)
  to
  [`add_rstudioconnect_file()`](https://thinkr-open.github.io/golem/reference/rstudio_deploy.md)
- Renamed `create_shiny_template()` to
  [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
- Renamed `js()` to
  [`activate_js()`](https://thinkr-open.github.io/golem/reference/golem_js.md)
- Renamed `use_recommended_dep()` to
  [`use_recommended_deps()`](https://thinkr-open.github.io/golem/reference/use_recommended.md)

### New functions

- [`invoke_js()`](https://thinkr-open.github.io/golem/reference/golem_js.md)
  allows to call JS functions from the server side.
  [\#52](https://github.com/ThinkR-open/golem/issues/52)

## golem 0.0.1.5000

### Changes

- The dev files are now split in three - start / dev / deploy

- Every function that adds a file now check if the file already exists,
  and ask the user if they want to overwrite it
  ([\#15](https://github.com/ThinkR-open/golem/issues/15))

- Every module is now named mod_x_ui / mod_x_server, for consistency.

- You can now create package with “illegal” names, using the command
  line `golem::create_shiny_template()`.
  [\#18](https://github.com/ThinkR-open/golem/issues/18)

- `add_browser_button()` is now named
  [`browser_button()`](https://thinkr-open.github.io/golem/reference/browser_button.md),
  so that all the `add_*` function are only reserved for function adding
  files to the `golem`.

- `add_*_files` now check if the folder exists, if not suggests to
  create it. [\#36](https://github.com/ThinkR-open/golem/issues/36)

### New functions

- You now have a
  [`browser_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md)
  function that behaves like `warning_dev` and friends.
  [\#46](https://github.com/ThinkR-open/golem/issues/46)

- Added
  [`set_golem_options()`](https://thinkr-open.github.io/golem/reference/golem_opts.md)
  to add local options used internally by {golem} && added it to the
  `01_start.R`. [\#49](https://github.com/ThinkR-open/golem/issues/49)

- Added
  [`add_dockerfile()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  to create a Dockerfile from a DESCRIPTION.

- Added
  [`add_dockerfile_shinyproxy()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  to create a Dockerfile from a DESCRIPTION, to be used in Shiny Proxy.

- Added
  [`add_dockerfile_heroku()`](https://thinkr-open.github.io/golem/reference/dockerfiles.md)
  to create a Dockerfile from a DESCRIPTION, to be used with Heroku.

- [`add_css_file()`](https://thinkr-open.github.io/golem/reference/add_files.md),
  [`add_js_file()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  and
  [`add_js_handler()`](https://thinkr-open.github.io/golem/reference/add_files.md)
  create a CSS, JS, and JS with Shiny custom handler files.

### Removed

- `use_utils_prod` is now included in golem so you don’t have to
  explicitly include the functions.

### Docs

- Golem now has four vignettes

## golem 0.0.1.0002

Last round of functions, and some documentation cleanup.

## golem 0.0.0.9000

- Moved from {shinytemplate} to {golem}

- Added a `NEWS.md` file to track changes to the package.
