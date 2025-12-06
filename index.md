# {golem} ![](https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png)

> You’re reading the doc about version: 0.5.1.9011. Note that
> [golem](https://thinkr-open.github.io/golem/) follows the [semantic
> versioning](https://semver.org/) scheme.

Production-grade [shiny](https://shiny.posit.co/) applications, from
creation to deployment.

[golem](https://thinkr-open.github.io/golem/) is an opinionated
framework that sets the standard for building production-grade
[shiny](https://shiny.posit.co/) applications. It provides a structured
environment that enforces best practices, fosters maintainability, and
ensures your applications are reliable, and ready for deployment in
real-world environments.

With [golem](https://thinkr-open.github.io/golem/), developers can focus
on creating high-quality, robust [shiny](https://shiny.posit.co/) apps
with confidence, knowing that the framework guides them through every
step of the development process.

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

![](https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png)

Or use the
[`golem::create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md)
function:

``` r
golem::create_golem("myapp")
```

See your app in action by running
[`golem::run_dev()`](https://thinkr-open.github.io/golem/reference/run_dev.md)
function.

Then, follow the scripts at:

- `dev/01_start.R` to configure your project at launch
- `dev/02_dev.R` for day to day development
- `dev/03_deploy.R` to build the deployment enabler for your app

## Resources

The [golem](https://thinkr-open.github.io/golem/) package is part of the
[`{golemverse}`](https://golemverse.org/), a series of tools for
building production [shiny](https://shiny.posit.co/) apps.

A list of various [golem](https://thinkr-open.github.io/golem/) related
resources (tutorials, video, blog post,…) can be found
[here](https://golemverse.org/resources/), along with blogposts, and
links to other packages of the `golemverse`.

------------------------------------------------------------------------

## Dev part

This `README` has been compiled on the

``` r
Sys.time()
#> [1] "2025-05-30 15:24:30 CEST"
```

Here are the test & coverage results:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading golem
#> ── R CMD check results ─────────────────────────────────── golem 0.5.1.9011 ────
#> Duration: 52.7s
#> 
#> ❯ checking for future file timestamps ... NOTE
#>   unable to verify current time
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
```

``` r
Sys.setenv("NOT_CRAN" = TRUE)
covr::package_coverage()
#> golem Coverage: 88.56%
#> R/boostrap_base.R: 0.00%
#> R/bootstrap_attachment.R: 0.00%
#> R/bootstrap_pkgload.R: 0.00%
#> R/bootstrap_roxygen2.R: 0.00%
#> R/bootstrap_rstudio_api.R: 0.00%
#> R/bootstrap_testthat.R: 0.00%
#> R/bootstrap_dockerfiler.R: 23.33%
#> R/test_helpers.R: 47.37%
#> R/bootstrap_desc.R: 55.56%
#> R/cli_msg.R: 75.64%
#> R/modules_fn.R: 76.44%
#> R/install_dev_deps.R: 78.26%
#> R/addins.R: 78.65%
#> R/add_r_files.R: 78.79%
#> R/config.R: 80.29%
#> R/add_rstudio_files.R: 80.82%
#> R/bootstrap_usethis.R: 85.45%
#> R/disable_autoload.R: 88.00%
#> R/reload.R: 88.64%
#> R/sanity_check.R: 88.64%
#> R/add_dockerfiles.R: 89.61%
#> R/add_dockerfiles_renv.R: 89.68%
#> R/make_dev.R: 90.00%
#> R/use_favicon.R: 90.82%
#> R/js.R: 93.75%
#> R/use_files_internal.R: 93.75%
#> R/use_recommended.R: 94.34%
#> R/add_files.R: 95.15%
#> R/create_golem.R: 95.86%
#> R/boostrap_cli.R: 96.43%
#> R/run_dev.R: 96.77%
#> R/desc.R: 96.84%
#> R/use_utils.R: 98.04%
#> R/utils.R: 99.32%
#> R/add_resource_path.R: 100.00%
#> R/boostrap_crayon.R: 100.00%
#> R/boostrap_fs.R: 100.00%
#> R/browser_button.R: 100.00%
#> R/bundle_resources.R: 100.00%
#> R/cats.R: 100.00%
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
