<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/dev/graph/badge.svg)](https://app.codecov.io/github/ThinkR-open/golem/tree/dev)[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

> You’re reading the doc about version: 0.5.0. Note that `{golem}`
> follows the [semantic versioning](https://semver.org/) scheme.

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

This `README` has been compiled on the

    Sys.time()
    #> [1] "2024-08-16 12:38:26 UTC"

Here are the test & coverage results:

    devtools::check(quiet = TRUE)
    #> ℹ Loading golem
    #> ── R CMD check results ──────────────────────────────────────── golem 0.5.0 ────
    #> Duration: 44.9s
    #> 
    #> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔

    Sys.setenv("NOT_CRAN" = TRUE);covr::package_coverage()
    #> golem Coverage: 84.85%
    #> R/boostrap_base.R: 0.00%
    #> R/bootstrap_attachment.R: 0.00%
    #> R/bootstrap_pkgload.R: 0.00%
    #> R/bootstrap_roxygen2.R: 0.00%
    #> R/bootstrap_rstudio_api.R: 0.00%
    #> R/bootstrap_testthat.R: 0.00%
    #> R/bootstrap_dockerfiler.R: 23.33%
    #> R/bootstrap_usethis.R: 28.57%
    #> R/test_helpers.R: 47.37%
    #> R/bootstrap_desc.R: 55.56%
    #> R/addins.R: 66.67%
    #> R/modules_fn.R: 75.74%
    #> R/after_creation_msg.R: 76.39%
    #> R/create_golem.R: 77.12%
    #> R/add_rstudio_files.R: 77.88%
    #> R/install_dev_deps.R: 78.26%
    #> R/add_r_files.R: 78.70%
    #> R/config.R: 79.23%
    #> R/use_files.R: 80.40%
    #> R/reload.R: 84.69%
    #> R/disable_autoload.R: 85.00%
    #> R/add_dockerfiles.R: 87.10%
    #> R/sanity_check.R: 87.18%
    #> R/make_dev.R: 90.00%
    #> R/use_favicon.R: 90.32%
    #> R/add_dockerfiles_renv.R: 91.95%
    #> R/add_files.R: 93.14%
    #> R/golem-yaml-get.R: 93.18%
    #> R/js.R: 93.75%
    #> R/run_dev.R: 95.65%
    #> R/desc.R: 96.77%
    #> R/use_recommended.R: 97.37%
    #> R/use_utils.R: 97.40%
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
