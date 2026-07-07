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

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

The path to the file, invisibly.

## Examples

``` r
if (interactive()) {
  disable_autoload()
}
```
