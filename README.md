
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/ThinkR-open/golem.svg?branch=master)](https://travis-ci.org/ThinkR-open/golem)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/master/graph/badge.svg)](https://codecov.io/github/ThinkR-open/golem?branch=master)

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" width=250px>

# {golem}

{golem} is a package that provides tools for a better workflow for
working on shinyapps.

## Tool series

This package is part of a series of tools for Shiny, which includes:

  - `{golem}` - <https://github.com/ThinkR-open/golem>
  - `{shinipsum}` - <https://github.com/ThinkR-open/shinipsum>
  - `{fakir}` - <https://github.com/ThinkR-open/fakir>
  - `{shinysnippets}` - <https://github.com/ThinkR-open/shinysnippets>

## Know more

### The Book :

  - <https://thinkr-open.github.io/building-shiny-apps-workflow/>

### Building big Shiny Apps :

  - Part 1:
    <https://rtask.thinkr.fr/blog/building-big-shiny-apps-a-workflow-1/>
  - Part 2:
    <https://rtask.thinkr.fr/blog/building-big-shiny-apps-a-workflow-2/>

### Blog post :

<https://rtask.thinkr.fr/blog/our-shiny-template-to-design-a-prod-ready-app>

## Installation

You can install the development version from
[GitHub](https://github.com/Thinkr-open/golem) with:

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem")
```

## Launch the project

Create a new package with the project
template:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

## Step by step guide

See full documentation in the {pkgdown} website:
<https://thinkr-open.github.io/golem/index.html>

After project creation, you’ll land on `dev/01_start.R`. There are also
`dev/02_dev.R` and `dev/03_deploy.R`

These files arer used to keep a track of all the steps you’ve followed
to build your app.

You can follow them step by step of skip some if you’d like.

### Fill the description

`golem::fill_desc()` allows to fill the DESCRIPTION quickly.

``` r
golem::fill_desc(
  pkg_name = , # The Name of the package containing the App 
  pkg_title = , # The Title of the package containing the App 
  pkg_description = , # The Description of the package containing the App 
  author_first_name = , # Your First Name
  author_last_name = , # Your Last Name
  author_email = , # Your Email
  repo_url = NULL) # The (optional) URL of the GitHub Repo
```

### Set common Files

Call the {usethis} package to set a list of elements:

``` r
usethis::use_mit_license(name = "Your Name")
usethis::use_readme_rmd()
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md()
```

If you have data in your app:

``` r
usethis::use_data_raw()
```

### Use Recommended Package

This adds a series of packages as dependecies to your app. See
`?golem::use_recommended_dep` for the
list.

``` r
golem::use_recommended_dep(recommended = c("shiny","DT","attempt","glue","htmltools","golem"))
```

### Add various tools

These two functions adds one file each which contain a series of
functions that can be useful for building your app. To be used in the
UI, in the server, or as prod-dependent tools.

``` r
golem::use_utils_ui()
golem::use_utils_server()
```

Somes JS functions can also be used inside your shiny app with:

``` r
golem::js()
```

See `?golem::js` for the list.

### Add a browser button

``` r
golem::add_browser_button()
```

See [A little trick for debugging
Shiny](https://rtask.thinkr.fr/blog/a-little-trick-for-debugging-shiny/)
for more info about this method.

### Create modules

This function takes a name xxx and creates a module called `mod_xxx.R`
in the R folder.

``` r
golem::add_module(name = "this")
```

The new file will contain:

``` r
# mod_UI
mod_this_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}

mod_this_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_this_ui("this1")
    
## To be copied in the server
# callModule(mod_this_server, "this1")
 
```

### Add or change favicon

``` r
golem::use_favicon()
golem::use_favicon(path = "path/to/your/favicon.ico")
```

### Add tests

Adds the recommended tests for a shiny app.

``` r
golem::use_recommended_tests()
```

### app\_prod

There’s a series of tools to make your app behave differently whether
it’s in dev or prod mode. Notably, the `app_prod()` and `app_dev()`
function tests for `options( "golem.app.prod")` (or return TRUE if this
option doesn’t exist).

Setting this options at the beginning of your dev process allows to make
your app behave in a specific way when you are in dev mode. For example,
printing message to the console with `cat_dev()`.

``` r
options( "golem.app.prod" = TRUE)
golem::cat_dev("hey\n")
options( "golem.app.prod" = FALSE)
golem::cat_dev("hey\n")
#> hey
```

You can then make any function being “dev-dependant” with the
`make_dev()` function:

``` r
log_dev <- golem::make_dev(log)
log_dev(10)
#> [1] 2.302585
options( "golem.app.prod" = TRUE)
log_dev(10)
```

## Quick reload and show application

*see the `run_dev.R` file in the dev directory*

``` r

# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()
mypkg::run_app()
```

## Deployment tools

### direct

Once the package (*e.g.* mypkg) is installed, the application can be
launch with the following command.

``` r
mypkg::run_app()
```

Or by running the `dev/run_dev.R` file.

### rsconnect

This creates a simple file at the root of the package, to be used to
deploy to RStudio Connect.

``` r
golem::add_rconnect_file()
```

### docker ( for shinyproxy and other )

``` r
golem::add_dockerfile()
```

## CoC

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
