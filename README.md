
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/master/graph/badge.svg)](https://codecov.io/github/ThinkR-open/golem?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

`{golem}` is an opinionated framework for building production-grade
shiny applications.

## Installation

- You can install the stable version from CRAN with:

``` r
install.packages("golem")
```

- You can install the development version from
  [GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem") # very close to CRAN version
# remotes::install_github("Thinkr-open/golem@dev") # if you like to play
```

## Resources

The `{golem}` package is part of the
[`{golemverse}`](https://golemverse.org/), a series of tools for Shiny.
A list of various `{golem}` related resources (tutorials, video, blog
post,…) can be found [here](https://golemverse.org/resources/).

## Launch the project

Create a new package with the project template:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

## Step by step guide

See full documentation in the `{pkgdown}` website:

\[CRAN\] <https://thinkr-open.github.io/golem/>

\[dev\] <https://thinkr-open.github.io/golem/dev/>

After project creation, you’ll land on `dev/01_start.R`. There are also
`dev/02_dev.R` and `dev/03_deploy.R`

These files are used to keep a track of all the steps you’ll be
following while building your app.

### Step 1 : Getting Started

Read [the Getting
Started](https://thinkr-open.github.io/golem/articles/a_start.html)
Vignette for a detailed walkthrough.

### Step 2 : Day to Day Dev

Read [Day to Day
Dev](https://thinkr-open.github.io/golem/articles/b_dev.html) Vignette
for a detailed walkthrough.

### Step 3: deploy

Read [Deploying Apps with
{golem}](https://thinkr-open.github.io/golem/articles/c_deploy.html)
Vignette for a detailed walkthrough.

## Tool series

This package is part of a series of tools for Shiny, which includes:

- `{golem}` - <https://github.com/ThinkR-open/golem>
- `{shinipsum}` - <https://github.com/ThinkR-open/shinipsum>
- `{fakir}` - <https://github.com/ThinkR-open/fakir>
- `{gemstones}` - <https://github.com/ThinkR-open/gemstones>

## Examples apps

These are examples from the community. Please note that they may not
necessarily be written in a canonical fashion and may have been written
with different versions of `{golem}` or `{shiny}`.

- <https://github.com/seanhardison1/vcrshiny>
- <https://github.com/Nottingham-and-Nottinghamshire-ICS/healthcareSPC>
- <https://github.com/marton-balazs-kovacs/tenzing>
- <https://github.com/shahreyar-abeer/cranstars>

You can also find apps at:

- <https://connect.thinkr.fr/connect/>
- <https://github.com/ColinFay/golemexamples>

## About

You’re reading the doc about version: 0.4.16

This `README` has been compiled on the

``` r
Sys.time()
#> [1] "2023-10-11 10:56:39 CEST"
```

Here are the test & coverage results:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading golem
#> ── R CMD check results ─────────────────────────────────────── golem 0.4.16 ────
#> Duration: 1m 12.7s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

``` r
covr::package_coverage()
#> golem Coverage: 73.76%
#> R/add_dockerfiles_renv.R: 0.00%
#> R/add_dockerfiles.R: 0.00%
#> R/addins.R: 0.00%
#> R/bootstrap_attachment.R: 0.00%
#> R/bootstrap_dockerfiler.R: 0.00%
#> R/bootstrap_rstudio_api.R: 0.00%
#> R/enable_roxygenize.R: 0.00%
#> R/get_sysreqs.R: 0.00%
#> R/globals.R: 0.00%
#> R/sanity_check.R: 0.00%
#> R/with_opt.R: 9.68%
#> R/test_helpers.R: 30.26%
#> R/use_readme.R: 34.29%
#> R/js.R: 43.75%
#> R/reload.R: 45.36%
#> R/use_recommended.R: 54.55%
#> R/bootstrap_desc.R: 55.56%
#> R/install_dev_deps.R: 60.87%
#> R/bootstrap_usethis.R: 70.00%
#> R/modules_fn.R: 79.00%
#> R/utils.R: 79.78%
#> R/golem-yaml-set.R: 83.02%
#> R/use_utils.R: 83.33%
#> R/use_favicon.R: 85.56%
#> R/add_rstudio_files.R: 88.52%
#> R/add_resource_path.R: 88.89%
#> R/create_golem.R: 89.47%
#> R/make_dev.R: 90.00%
#> R/add_r_files.R: 91.01%
#> R/add_files.R: 91.96%
#> R/golem-yaml-get.R: 93.18%
#> R/run_dev.R: 95.65%
#> R/desc.R: 96.67%
#> R/boostrap_cli.R: 100.00%
#> R/boostrap_crayon.R: 100.00%
#> R/boostrap_fs.R: 100.00%
#> R/bootstrap_pkgload.R: 100.00%
#> R/bootstrap_roxygen2.R: 100.00%
#> R/browser_button.R: 100.00%
#> R/bundle_resources.R: 100.00%
#> R/config.R: 100.00%
#> R/disable_autoload.R: 100.00%
#> R/golem-yaml-utils.R: 100.00%
#> R/is_golem.R: 100.00%
#> R/is_running.R: 100.00%
#> R/pkg_tools.R: 100.00%
#> R/set_golem_options.R: 100.00%
#> R/templates.R: 100.00%
#> R/use_files.R: 100.00%
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
