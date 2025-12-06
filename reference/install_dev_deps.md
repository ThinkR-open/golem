# Install `{golem}` dev dependencies

This function will run rlang::check_installed() on:

- usethis

- pkgload

- dockerfiler

- devtools

- roxygen2

- attachment

- rstudioapi

- fs

- desc

- pkgbuild

- processx

- rsconnect

- testthat

- rstudioapi

## Usage

``` r
install_dev_deps(dev_deps, force_install = FALSE, ...)
```

## Arguments

- dev_deps:

  optional character vector of packages to install

- force_install:

  If force_install is TRUE, then the user is not interactively asked to
  install them.

- ...:

  further arguments passed to the install function.

## Value

Used for side-effects

## Examples

``` r
if (interactive()) {
  install_dev_deps()
}
```
