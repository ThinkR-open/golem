# Is the running app a golem app?

Note that this will return `TRUE` only if the application has been
launched with
[`with_golem_options()`](https://thinkr-open.github.io/golem/reference/with_golem_options.md)

## Usage

``` r
is_running()
```

## Value

TRUE if the running app is a `{golem}` based app, FALSE otherwise.

## Examples

``` r
is_running()
#> [1] FALSE
```
