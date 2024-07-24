
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

![](https://img.shields.io/badge/r%20package-%23276DC3.svg?style=for-the-badge&logo=r)

[![CRAN](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)
[![downloads
monthly](https://cranlogs.r-pkg.org/badges/golem)](https://CRAN.R-project.org/package=golem)
[![downloads
total](https://cranlogs.r-pkg.org/badges/grand-total/golem)](https://CRAN.R-project.org/package=golem)

[![R-CMD-check](https://github.com/ThinkR-open/golem/workflows/R-CMD-check/badge.svg)](https://github.com/ThinkR-open/golem/actions)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/use-bslib/graph/badge.svg)](https://app.codecov.io/github/ThinkR-open/golem/tree/use-bslib)

<!-- badges: end -->

# {golem} <img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" align="right" width="120"/>

`Golem` is an opinionated framework for building production-grade shiny
applications. It is designed to help you build robust, maintainable
shiny apps, with a consistent structure and workflow.

This package helps you to:

-   **Build** a shiny application with a solid foundation inside a
    package,
-   **Develop** your application in a robust and scalable way,
-   **Test** your application with a set of tools and best practices,
-   **Deploy** your application in a production-ready environment.

## Installation

You can install the stable version from CRAN with:

``` r
install.packages("golem")
```

You can install the development version from
[GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem")
```

## Create a new application with `golem`

### With RStudio

If you are developping in RStudio, you can use the `golem` RStudio addin
to create a new application.

Go to `File` \> `New Project` \> `New Directory` \> Search for
`Package for Shiny App using golem`:

<img src="man/figures/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

### With R

You can also create a new application with the following R code:

``` r
golem::create_golem("mygolemapp")
```

Run this code in your R console will create a new golem application in a
folder called `mygolemapp` where you run the code.

A new Rstudio window will open with the new project.

## Launch your app

Once your project is created, you can run your app with the following
code:

``` r
golem::run_dev()
```

Enjoy your new app!

## Discover {golem}

Golem documentation is available at
<https://thinkr-open.github.io/golem/>.

<!-- TODO: add more links -->

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct.html).
By participating in this project you agree to abide by its terms.
