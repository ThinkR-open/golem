# Disabling Shiny Autoload of R Scripts

Disabling Shiny Autoload of R Scripts

## Usage

``` r
disable_autoload(golem_wd = get_golem_wd(), pkg)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- pkg:

  Deprecated, please use golem_wd instead

## Value

The path to the file, invisibly.

## Examples

``` r
if (interactive()) {
  disable_autoload()
}
```
