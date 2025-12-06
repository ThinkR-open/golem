# Functions already made dev dependent

This functions will be run only if
[`golem::app_dev()`](https://thinkr-open.github.io/golem/reference/prod.md)
returns TRUE.

## Usage

``` r
cat_dev(...)

print_dev(...)

message_dev(...)

warning_dev(...)

browser_dev(...)
```

## Arguments

- ...:

  R objects (see ‘Details’ for the types of objects allowed).

## Value

A modified function.
