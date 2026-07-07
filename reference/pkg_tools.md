# Package tools

These are functions to help you navigate inside your project while
developing

## Usage

``` r
pkg_name(golem_wd = get_golem_wd(), path)

pkg_version(golem_wd = get_golem_wd(), path)

pkg_path(golem_wd = getwd())
```

## Arguments

- golem_wd:

  Path to use to read the DESCRIPTION

- path:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

The value of the entry in the DESCRIPTION file
