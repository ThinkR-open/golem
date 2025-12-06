# Is the directory a golem-based app?

Trying to guess if `path` is a golem-based app.

## Usage

``` r
is_golem(path = getwd())
```

## Arguments

- path:

  Path to the directory to check. Defaults to the current working
  directory.

## Value

A boolean, `TRUE` if the directory is a golem-based app, `FALSE` else.

## Examples

``` r
is_golem()
#> [1] FALSE
```
