<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/dev/graph/badge.svg)](https://app.codecov.io/github/ThinkR-open/golem/tree/dev)[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

Production-grade `{shiny}` applications, from creation to deployment.

`{golem}` is an opinionated framework that sets the standard for
building production-grade `{shiny}` applications. It provides a
structured environment that enforces best practices, fosters
maintainability, and ensures your applications are reliable, and ready
for deployment in real-world environments.

With `{golem}`, developers can focus on creating high-quality, robust
`{shiny}` apps with confidence, knowing that the framework guides them
through every step of the development process.

## Installation

-   You can install the stable version from CRAN with:

<!-- -->

    install.packages("golem")

-   You can install the development version from
    [GitHub](https://github.com/Thinkr-open/golem) with:

<!-- -->

    # install.packages("remotes")
    remotes::install_github("Thinkr-open/golem") # Stable development version
    # remotes::install_github("Thinkr-open/golem@dev") # Bleeding edge development version

## Get Started

Create a new app with the project template from RStudio:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

Or use the `golem::create_golem()` function:

    golem::create_golem("myapp")

See your app in action by running `golem::run_dev()` function.

Then, follow the scripts at:

-   `dev/01_start.R` to configure your project at launch
-   `dev/02_dev.R` for day to day development
-   `dev/03_deploy.R` to build the deployment enabler for your app

## Resources

The `{golem}` package is part of the
[`{golemverse}`](https://golemverse.org/), a series of tools for
building production `{shiny}` apps.

A list of various `{golem}` related resources (tutorials, video, blog
post,…) can be found [here](https://golemverse.org/resources/), along
with blogposts, and links to other packages of the `golemverse`.

------------------------------------------------------------------------

## Dev part

You’re reading the doc about version: 0.5.3

This `README` has been compiled on the

    Sys.time()
    #> [1] "2024-08-16 09:03:08 UTC"

Here are the test & coverage results:

    devtools::check(quiet = TRUE)
    #> ℹ Loading golem
    #> ── R CMD check results ──────────────────────────────────────── golem 0.5.3 ────
    #> Duration: 44s
    #> 
    #> ❯ checking tests ...
    #>   See below...
    #> 
    #> ── Test failures ───────────────────────────────────────────────── testthat ────
    #> 
    #> > # This file is part of the standard setup for testthat.
    #> > # It is recommended that you do not modify it.
    #> > #
    #> > # Where should you do additional test configuration?
    #> > # Learn more about the roles of various files in:
    #> > # * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
    #> > # * https://testthat.r-lib.org/articles/special-files.html
    #> > 
    #> > library(testthat)
    #> > library(golem)
    #> > 
    #> > test_check("golem")
    #> Starting 2 test processes
    #> [ FAIL 2 | WARN 0 | SKIP 0 | PASS 235 ]
    #> 
    #> ══ Failed tests ════════════════════════════════════════════════════════════════
    #> ── Error ('test-use_utils.R:32:7'): use_utils_ui works ─────────────────────────
    #> <usethis_error/rlang_error/error/condition>
    #> Error in `proj_set(".")`: x Path '/tmp/RtmpQVYPK3/file200f24bd2a38/golem.Rcheck/tests/testthat/' does not appear to be inside a project or package.
    #> i Read more in the help for `usethis::proj_get()`.
    #> Backtrace:
    #>      ▆
    #>   1. ├─withr::with_options(...) at test-use_utils.R:27:3
    #>   2. │ └─base::force(code)
    #>   3. └─golem::use_utils_ui(pkg = pkg, with_test = TRUE) at test-use_utils.R:32:7
    #>   4.   └─golem:::usethis_use_testthat()
    #>   5.     └─usethis::use_testthat(edition, parallel)
    #>   6.       └─usethis:::use_testthat_impl(edition, parallel = parallel)
    #>   7.         └─usethis::use_directory(path("tests", "testthat"))
    #>   8.           ├─usethis:::create_directory(proj_path(path))
    #>   9.           │ └─fs::dir_exists(path)
    #>  10.           │   └─fs::is_dir(path)
    #>  11.           │     └─fs::file_info(path, follow = follow)
    #>  12.           │       └─fs::path_expand(path)
    #>  13.           └─usethis::proj_path(path)
    #>  14.             ├─fs::path_norm(path(proj_get(), ..., ext = ext))
    #>  15.             ├─fs::path(proj_get(), ..., ext = ext)
    #>  16.             └─usethis::proj_get()
    #>  17.               └─usethis::proj_set(".")
    #>  18.                 └─usethis:::ui_abort(...)
    #>  19.                   └─cli::cli_abort(...)
    #>  20.                     └─rlang::abort(...)
    #> ── Error ('test-use_utils.R:132:7'): use_utils_ui works ────────────────────────
    #> <usethis_error/rlang_error/error/condition>
    #> Error in `proj_set(".")`: x Path '/tmp/RtmpQVYPK3/file200f24bd2a38/golem.Rcheck/tests/testthat/' does not appear to be inside a project or package.
    #> i Read more in the help for `usethis::proj_get()`.
    #> Backtrace:
    #>      ▆
    #>   1. ├─withr::with_options(...) at test-use_utils.R:127:3
    #>   2. │ └─base::force(code)
    #>   3. └─golem::use_utils_server(pkg = pkg, with_test = TRUE) at test-use_utils.R:132:7
    #>   4.   └─golem:::usethis_use_testthat()
    #>   5.     └─usethis::use_testthat(edition, parallel)
    #>   6.       └─usethis:::use_testthat_impl(edition, parallel = parallel)
    #>   7.         └─usethis::use_directory(path("tests", "testthat"))
    #>   8.           ├─usethis:::create_directory(proj_path(path))
    #>   9.           │ └─fs::dir_exists(path)
    #>  10.           │   └─fs::is_dir(path)
    #>  11.           │     └─fs::file_info(path, follow = follow)
    #>  12.           │       └─fs::path_expand(path)
    #>  13.           └─usethis::proj_path(path)
    #>  14.             ├─fs::path_norm(path(proj_get(), ..., ext = ext))
    #>  15.             ├─fs::path(proj_get(), ..., ext = ext)
    #>  16.             └─usethis::proj_get()
    #>  17.               └─usethis::proj_set(".")
    #>  18.                 └─usethis:::ui_abort(...)
    #>  19.                   └─cli::cli_abort(...)
    #>  20.                     └─rlang::abort(...)
    #> 
    #> [ FAIL 2 | WARN 0 | SKIP 0 | PASS 235 ]
    #> Error: Test failures
    #> Execution halted
    #> 
    #> 1 error ✖ | 0 warnings ✔ | 0 notes ✔
    #> Error: R CMD check found ERRORs

    Sys.setenv("NOT_CRAN" = TRUE);covr::package_coverage()
    #> golem Coverage: 79.96%
    #> R/boostrap_base.R: 0.00%
    #> R/bootstrap_attachment.R: 0.00%
    #> R/bootstrap_pkgload.R: 0.00%
    #> R/bootstrap_roxygen2.R: 0.00%
    #> R/bootstrap_rstudio_api.R: 0.00%
    #> R/bootstrap_dockerfiler.R: 23.33%
    #> R/test_helpers.R: 30.26%
    #> R/config.R: 37.69%
    #> R/bootstrap_usethis.R: 38.57%
    #> R/bootstrap_desc.R: 55.56%
    #> R/after_creation_msg.R: 59.72%
    #> R/install_dev_deps.R: 60.87%
    #> R/create_golem.R: 64.71%
    #> R/addins.R: 66.67%
    #> R/modules_fn.R: 73.76%
    #> R/add_files.R: 77.06%
    #> R/add_rstudio_files.R: 77.88%
    #> R/add_r_files.R: 78.70%
    #> R/use_files.R: 80.40%
    #> R/desc.R: 83.87%
    #> R/reload.R: 84.69%
    #> R/disable_autoload.R: 85.00%
    #> R/add_dockerfiles.R: 87.10%
    #> R/sanity_check.R: 87.18%
    #> R/make_dev.R: 90.00%
    #> R/use_favicon.R: 90.32%
    #> R/add_dockerfiles_renv.R: 91.95%
    #> R/golem-yaml-get.R: 93.18%
    #> R/js.R: 93.75%
    #> R/use_recommended.R: 94.59%
    #> R/run_dev.R: 95.65%
    #> R/utils.R: 99.19%
    #> R/add_resource_path.R: 100.00%
    #> R/boostrap_cli.R: 100.00%
    #> R/boostrap_crayon.R: 100.00%
    #> R/boostrap_fs.R: 100.00%
    #> R/browser_button.R: 100.00%
    #> R/bundle_resources.R: 100.00%
    #> R/cats.R: 100.00%
    #> R/enable_roxygenize.R: 100.00%
    #> R/get_sysreqs.R: 100.00%
    #> R/globals.R: 100.00%
    #> R/golem_welcome_page.R: 100.00%
    #> R/golem-yaml-set.R: 100.00%
    #> R/golem-yaml-utils.R: 100.00%
    #> R/is_golem.R: 100.00%
    #> R/is_running.R: 100.00%
    #> R/maintenance_page.R: 100.00%
    #> R/pkg_tools.R: 100.00%
    #> R/set_golem_options.R: 100.00%
    #> R/templates.R: 100.00%
    #> R/use_readme.R: 100.00%
    #> R/use_utils.R: 100.00%
    #> R/with_opt.R: 100.00%

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct.html).
By participating in this project you agree to abide by its terms.

## Note for the contributors

Please style the files according to `grkstyle::grk_style_transformer()`

    # If you work in RStudio
    options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")

    # If you work in VSCode
    options(languageserver.formatting_style = function(options) {
      grkstyle::grk_style_transformer()
    })
