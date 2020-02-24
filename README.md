
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/ThinkR-open/golem.svg?branch=master)](https://travis-ci.org/ThinkR-open/golem)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/ThinkR-open/golem?branch=master&svg=true)](https://ci.appveyor.com/project/ThinkR-open/golem)
[![Coverage
status](https://codecov.io/gh/ThinkR-open/golem/branch/master/graph/badge.svg)](https://codecov.io/github/ThinkR-open/golem?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/golem)](https://cran.r-project.org/package=golem)

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/rstudio/templates/project/golem.png" width="250px" style="display: block; margin: auto auto auto 0;" />

# {golem}

`{golem}` is an opinionated framework for building production-grade
shiny applications.

## Tool series

This package is part of a series of tools for Shiny, which includes:

  - `{golem}` - <https://github.com/ThinkR-open/golem>
  - `{shinipsum}` - <https://github.com/ThinkR-open/shinipsum>
  - `{fakir}` - <https://github.com/ThinkR-open/fakir>
  - `{shinysnippets}` - <https://github.com/ThinkR-open/shinysnippets>

## Resources

### The Book :

  - <https://thinkr-open.github.io/building-shiny-apps-workflow/>

### Blog posts :

*Building Big Shiny Apps*

  - Part 1:
    <https://rtask.thinkr.fr/blog/building-big-shiny-apps-a-workflow-1/>
  - Part 2:
    <https://rtask.thinkr.fr/blog/building-big-shiny-apps-a-workflow-2/>

### Slide decks

  - useR\! 2019 : [A Framework for Building Robust & Production Ready
    Shiny
    Apps](https://github.com/VincentGuyader/user2019/raw/master/golem_Vincent_Guyader_USER!2019.pdf)
  - ThinkR x RStudio Roadshow,Paris : [Production-grade Shiny Apps with
    {golem}](https://speakerdeck.com/colinfay/production-grade-shiny-apps-with-golem)
  - rstudio::conf(2020) : [Production-grade Shiny Apps with
    golem](https://speakerdeck.com/colinfay/rstudio-conf-2020-production-grade-shiny-apps-with-golem)

### Video

  - [{golem} and Effective Shiny Development
    Methods](https://www.youtube.com/watch?v=OU1-CkSVdTI)
  - [Hands-on demonstration of
    {golem}](https://shinydevseries.com/post/golem-demo/)
  - useR\! 2019 : [A Framework for Building Robust & Production Ready
    Shiny Apps](https://youtu.be/tCAan6smrjs)
  - 🇫🇷 [Introduction to {golem}](https://youtu.be/6qI4NzxlAFU)
  - rstudio::conf(2020) : [Production-grade Shiny Apps with
    golem](https://resources.rstudio.com/rstudio-conf-2020/production-grade-shiny-apps-with-golem-colin-fay)

### Cheatsheet

  - [{golem} cheatsheet](https://thinkr.fr/golem_cheatsheet_v0.1.pdf)

## Installation

  - You can install the stable version from CRAN with:

<!-- end list -->

``` r
install.packages("golem")
```

  - You can install the development version from
    [GitHub](https://github.com/Thinkr-open/golem) with:

<!-- end list -->

``` r
# install.packages("remotes")
remotes::install_github("Thinkr-open/golem")
```

## Launch the project

Create a new package with the project template:

<img src="https://raw.githubusercontent.com/ThinkR-open/golem/master/inst/img/golemtemplate.png" width="80%" style="display: block; margin: auto;" />

## Step by step guide

See full documentation in the {pkgdown} website:
<https://thinkr-open.github.io/golem/index.html>

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
