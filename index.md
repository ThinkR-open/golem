# {golem} ![](https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png)

> You’re reading the doc about version: 1.0.0. Note that
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
  [GitHub](https://github.com/ThinkR-open/golem) with:

``` r

# install.packages("remotes")
remotes::install_github("ThinkR-open/golem") # Stable development version
# remotes::install_github("ThinkR-open/golem@dev") # Bleeding edge development version
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
#> [1] "2026-06-17 15:41:54 CEST"
```

Here are the test & coverage results:

``` r

devtools::check(quiet = TRUE)
#> ── R CMD check results ──────────────────────────────────────── golem 1.0.0 ────
#> Duration: 47.7s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

``` r

Sys.setenv("NOT_CRAN" = TRUE)
covr::package_coverage()
#> golem Coverage: 88.92%
#> R/boostrap_base.R: 0.00%
#> R/bootstrap_attachment.R: 0.00%
#> R/bootstrap_pkgload.R: 0.00%
#> R/bootstrap_roxygen2.R: 0.00%
#> R/bootstrap_rstudio_api.R: 0.00%
#> R/bootstrap_testthat.R: 0.00%
#> R/bootstrap_dockerfiler.R: 23.33%
#> R/test_helpers.R: 45.06%
#> R/boostrap_cli.R: 66.33%
#> R/bootstrap_desc.R: 73.33%
#> R/addins.R: 76.00%
#> R/add_r_files.R: 80.06%
#> R/install_dev_deps.R: 80.70%
#> R/add_dockerfiles_renv.R: 81.97%
#> R/modules_fn.R: 82.48%
#> R/reload.R: 84.28%
#> R/bootstrap_usethis.R: 85.45%
#> R/js.R: 86.21%
#> R/add_rstudio_files.R: 87.12%
#> R/add_dockerfiles.R: 88.50%
#> R/create_golem.R: 89.63%
#> R/add_ci_files.R: 89.74%
#> R/cli_msg.R: 90.62%
#> R/use_agent_skills.R: 91.27%
#> R/sanity_check.R: 91.86%
#> R/disable_autoload.R: 91.89%
#> R/use_favicon.R: 93.88%
#> R/add_files.R: 95.13%
#> R/use_recommended.R: 95.89%
#> R/use_files_internal.R: 96.00%
#> R/use_files_external.R: 96.20%
#> R/utils.R: 97.14%
#> R/create_golem_helpers.R: 97.56%
#> R/desc.R: 97.60%
#> R/make_dev.R: 97.78%
#> R/run_dev.R: 98.18%
#> R/use_utils.R: 98.96%
#> R/add_resource_path.R: 100.00%
#> R/boostrap_fs.R: 100.00%
#> R/browser_button.R: 100.00%
#> R/bundle_resources.R: 100.00%
#> R/config.R: 100.00%
#> R/enable_roxygenize.R: 100.00%
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

Please format the files with [`air`](https://posit-dev.github.io/air/)
before submitting a contribution:

``` sh
air format .
```

The repository also ships a pre-commit hook that runs `air`
automatically (see `.pre-commit-config.yaml`).
