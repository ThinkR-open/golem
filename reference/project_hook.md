# Project Hook

Project hooks allow to define a function run just after `{golem}`
project creation.

## Usage

``` r
project_hook(path, package_name, ...)
```

## Arguments

- path:

  Name of the folder to create the package in. This will also be used as
  the package name.

- package_name:

  Package name to use. By default, `{golem}` uses `basename(path)`. If
  `path == '.'` & `package_name` is not explicitly set, then
  `basename(getwd())` will be used.

- ...:

  Arguments passed from
  [`create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.md),
  unused in the default function.

## Value

Used for side effects

## Examples

``` r
if (interactive()) {
  my_proj <- function(...) {
    unlink("dev/", TRUE, TRUE)
  }
  create_golem("ici", project_template = my_proj)
}
```
