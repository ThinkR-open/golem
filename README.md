
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

## About

You’re reading the doc about version : 0.4.0

This README has been compiled on the

``` r
Sys.time()
#> [1] "2023-03-10 09:53:27 CET"
```

Here are the test & coverage results :

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading golem
#> ── R CMD check results ──────────────────────────────────────── golem 0.4.0 ────
#> Duration: 1m 23.6s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

``` r
covr::package_coverage()
#> golem Coverage: 69.16%
#> R/addins.R: 0.00%
#> R/bootstrap_rstudio_api.R: 0.00%
#> R/enable_roxygenize.R: 0.00%
#> R/get_sysreqs.R: 0.00%
#> R/gobals.R: 0.00%
#> R/run_dev.R: 0.00%
#> R/sanity_check.R: 0.00%
#> R/use_files.R: 0.00%
#> R/with_opt.R: 22.58%
#> R/config.R: 28.21%
#> R/test_helpers.R: 30.26%
#> R/js.R: 43.75%
#> R/reload.R: 45.36%
#> R/use_recommended.R: 54.55%
#> R/bootstrap_desc.R: 55.56%
#> R/install_dev_deps.R: 57.14%
#> R/utils.R: 58.30%
#> R/bootstrap_attachment.R: 61.54%
#> R/add_dockerfiles.R: 74.19%
#> R/bootstrap_usethis.R: 76.56%
#> R/boostrap_fs.R: 77.78%
#> R/modules_fn.R: 80.00%
#> R/use_utils.R: 83.33%
#> R/use_favicon.R: 85.56%
#> R/desc.R: 86.25%
#> R/add_resource_path.R: 88.89%
#> R/create_golem.R: 89.47%
#> R/make_dev.R: 90.00%
#> R/add_r_files.R: 91.67%
#> R/add_files.R: 92.31%
#> R/add_rstudio_files.R: 93.10%
#> R/golem-yaml-get.R: 93.18%
#> R/bootstrap_dockerfiler.R: 93.33%
#> R/add_dockerfiles_renv.R: 93.75%
#> R/boostrap_cli.R: 100.00%
#> R/boostrap_crayon.R: 100.00%
#> R/bootstrap_pkgload.R: 100.00%
#> R/bootstrap_roxygen2.R: 100.00%
#> R/browser_button.R: 100.00%
#> R/bundle_resources.R: 100.00%
#> R/disable_autoload.R: 100.00%
#> R/golem-yaml-set.R: 100.00%
#> R/golem-yaml-utils.R: 100.00%
#> R/is_running.R: 100.00%
#> R/pkg_tools.R: 100.00%
#> R/set_golem_options.R: 100.00%
#> R/templates.R: 100.00%
```

## Tool series

This package is part of a series of tools for Shiny, which includes:

- `{golem}` - <https://github.com/ThinkR-open/golem>
- `{shinipsum}` - <https://github.com/ThinkR-open/shinipsum>
- `{fakir}` - <https://github.com/ThinkR-open/fakir>
- `{gemstones}` - <https://github.com/ThinkR-open/gemstones>

## Resources

### The Book :

- <https://engineering-shiny.org/>

- [paper version of the book “Engineering Production-Grade Shiny
  Apps”](https://www.routledge.com/Engineering-Production-Grade-Shiny-Apps/Fay-Rochette-Guyader-Girard/p/book/9780367466022)

### Blog posts :

*Building Big Shiny Apps*

- Part 1:
  <https://rtask.thinkr.fr/building-big-shiny-apps-a-workflow-1/>
- Part 2:
  <https://rtask.thinkr.fr/building-big-shiny-apps-a-workflow-2/>

[*Make a Fitness App from
scratch*](https://towardsdatascience.com/production-grade-r-shiny-with-golem-prototyping-51b03f37c2a9)

### Slide decks

- useR! 2019 : [A Framework for Building Robust & Production Ready Shiny
  Apps](https://github.com/VincentGuyader/user2019/raw/master/golem_Vincent_Guyader_USER!2019.pdf)
- ThinkR x RStudio Roadshow,Paris : [Production-grade Shiny Apps with
  {golem}](https://speakerdeck.com/colinfay/production-grade-shiny-apps-with-golem)
- rstudio::conf(2020) : [Production-grade Shiny Apps with
  golem](https://speakerdeck.com/colinfay/rstudio-conf-2020-production-grade-shiny-apps-with-golem)
- barcelonar (2019-12-03) : [Engineering Production-Grade Shiny Apps
  with
  {golem}](https://www.barcelonar.org/presentations/BarcelonaR_Building_Production_Grade_Shiny_Apps_with_golem.pdf)

### Video

- [{golem} and Effective Shiny Development
  Methods](https://www.youtube.com/watch?v=OU1-CkSVdTI)
- [Hands-on demonstration of
  {golem}](https://www.youtube.com/watch?v=3-p9XLvoJV0)
- useR! 2019 : [A Framework for Building Robust & Production Ready Shiny
  Apps](https://youtu.be/tCAan6smrjs)
- 🇫🇷 [Introduction to {golem}](https://youtu.be/6qI4NzxlAFU)
- rstudio::conf(2020) : [Production-grade Shiny Apps with
  golem](https://posit.co/resources/videos/production-grade-shiny-apps-with-golem/)
- 🇫🇷 Rencontres R 2021 : [Conception d’applications Shiny avec
  {golem}](https://www.youtube.com/watch?v=0f5Me1PFGDs)
- 🇫🇷 [Déploiement d’une application {shiny} dans docker avec {renv} et
  {golem}](https://www.youtube.com/watch?v=diCG4t76k78)

### Cheatsheet

- [{golem} cheatsheet](https://thinkr.fr/golem_cheatsheet_v0.1.pdf)

### Examples apps

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

## Installation

- You can install the stable version from CRAN with:

``` r
install.packages("golem")
```

- You can install the development version from
  [GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem")
```

## Launch the project

Create a new package with the project template:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

## Step by step guide

See full documentation in the {pkgdown} website:

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
