#' Generate a README.Rmd
#'
#' @param overwrite an optional \code{logical} flag; if \code{TRUE}, overwrite
#'   existing \code{README.Rmd}, else throws an error if \code{README.Rmd} exists
#'
#' @return pure side-effect function that generates template \code{README.Rmd}
#' @export
use_readme_rmd <- function(overwrite = FALSE) {
  stopifnot(`Arg. 'overwrite' must be logical` = is.logical(overwrite))

  tmp_pth <- get_rmd_pth()
  check_overwrite(overwrite, tmp_pth)

  readme_tmpl <- generate_readme_tmpl(
    pkg_name = pkg_name()
  )

  writeLines(
    text = readme_tmpl,
    con = file.path(tmp_pth)
  )
}
get_rmd_pth <- function() {
  file.path(
    get_golem_wd(),
    "README.Rmd"
  )
}
check_overwrite <- function(overwrite, tmp_pth) {
  if (isTRUE(overwrite)) {
    file.create(tmp_pth)
  } else {
    if (file.exists(tmp_pth)) {
      stop("README.Rmd already exists. Set `overwrite = TRUE` to overwrite.")
    }
  }
}
generate_readme_tmpl <- function(pkg_name) {
  tmp_file <- '---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

```{r, include = FALSE}
  knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>",
    fig.path = "man/figures/README-",
    out.width = "100%"
)
```

# `{PKG}`

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of `{PKG}` like so:

```{r}
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

```{r, eval = FALSE}
PKG::run_app()
```

## About

You are reading the doc about version : `r golem::pkg_version()`

This README has been compiled on the

```{r}
Sys.time()
```

Here are the tests results and package coverage:

```{r, error = TRUE}
devtools::check(quiet = TRUE)
```

```{r echo = FALSE}
unloadNamespace("PKG")
```

```{r}
covr::package_coverage()
```
'
  tmp_file <- stringr::str_replace_all(
    tmp_file,
    "PKG",
    pkg_name
  )
  return(tmp_file)
}
