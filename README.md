
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/fix/create-if-needed/graph/badge.svg)](https://app.codecov.io/github/ThinkR-open/golem/tree/fix/create-if-needed)[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

> You’re reading the doc about version: 0.5.1.9015. Note that `{golem}`
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

- You can install the stable version from CRAN with:

``` r
install.packages("golem")
```

- You can install the development version from
  [GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem") # Stable development version
# remotes::install_github("Thinkr-open/golem@dev") # Bleeding edge development version
```

## Get Started

Create a new app with the project template from RStudio:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

Or use the `golem::create_golem()` function:

``` r
golem::create_golem("myapp")
```

See your app in action by running `golem::run_dev()` function.

Then, follow the scripts at:

- `dev/01_start.R` to configure your project at launch
- `dev/02_dev.R` for day to day development
- `dev/03_deploy.R` to build the deployment enabler for your app

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

``` r
Sys.time()
#> [1] "2026-04-13 10:36:56 CEST"
```

Here are the test & coverage results:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading golem
#> ── R CMD check results ─────────────────────────────────── golem 0.5.1.9015 ────
#> Duration: 45.2s
#> 
#> ❯ checking for future file timestamps ... NOTE
#>   unable to verify current time
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
```

``` r
Sys.setenv("NOT_CRAN" = TRUE)
covr::package_coverage()
#> golem Coverage: 87.99%
#> R/boostrap_base.R: 0.00%
#> R/bootstrap_attachment.R: 0.00%
#> R/bootstrap_pkgload.R: 0.00%
#> R/bootstrap_roxygen2.R: 0.00%
#> R/bootstrap_rstudio_api.R: 0.00%
#> R/bootstrap_testthat.R: 0.00%
#> R/bootstrap_dockerfiler.R: 23.33%
#> R/test_helpers.R: 45.06%
#> R/bootstrap_desc.R: 50.00%
#> R/addins.R: 76.00%
#> R/add_r_files.R: 78.81%
#> R/cli_msg.R: 80.36%
#> R/modules_fn.R: 80.62%
#> R/install_dev_deps.R: 80.70%
#> R/add_rstudio_files.R: 81.36%
#> R/add_dockerfiles_renv.R: 81.40%
#> R/reload.R: 82.83%
#> R/bootstrap_usethis.R: 85.45%
#> R/js.R: 86.21%
#> R/add_dockerfiles.R: 86.73%
#> R/sanity_check.R: 91.86%
#> R/disable_autoload.R: 91.89%
#> R/create_golem.R: 92.67%
#> R/boostrap_cli.R: 92.68%
#> R/add_files.R: 93.75%
#> R/use_favicon.R: 93.84%
#> R/use_files_internal.R: 95.83%
#> R/make_dev.R: 96.43%
#> R/utils.R: 96.93%
#> R/use_recommended.R: 96.94%
#> R/desc.R: 97.71%
#> R/run_dev.R: 98.18%
#> R/use_utils.R: 98.87%
#> R/add_resource_path.R: 100.00%
#> R/boostrap_crayon.R: 100.00%
#> R/boostrap_fs.R: 100.00%
#> R/browser_button.R: 100.00%
#> R/bundle_resources.R: 100.00%
#> R/cats.R: 100.00%
#> R/config.R: 100.00%
#> R/enable_roxygenize.R: 100.00%
#> R/get_sysreqs.R: 100.00%
#> R/globals.R: 100.00%
#> R/golem_welcome_page.R: 100.00%
#> R/golem-yaml-get.R: 100.00%
#> R/golem-yaml-set.R: 100.00%
#> R/golem-yaml-utils.R: 100.00%
#> R/is_golem.R: 100.00%
#> R/is_running.R: 100.00%
#> R/maintenance_page.R: 100.00%
#> R/pkg_tools.R: 100.00%
#> R/set_golem_options.R: 100.00%
#> R/templates.R: 100.00%
#> R/use_files_external_tools.R: 100.00%
#> R/use_files_external.R: 100.00%
#> R/use_files_internal_tools.R: 100.00%
#> R/use_files_shared_tools.R: 100.00%
#> R/use_readme.R: 100.00%
#> R/with_opt.R: 100.00%
```

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct.html).
By participating in this project you agree to abide by its terms.

## Note for the contributors

Please style the files according to `grkstyle::grk_style_transformer()`

``` r
# If you work in RStudio
options(styler.addins_style_transformer = "grkstyle::grk_style_transformer()")

# If you work in VSCode
options(languageserver.formatting_style = function(options) {
  grkstyle::grk_style_transformer()
})
```
