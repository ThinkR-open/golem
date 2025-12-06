# Package tools

These are functions to help you navigate inside your project while
developing

## Usage

``` r
pkg_name(golem_wd = get_golem_wd(), path)

pkg_version(golem_wd = get_golem_wd(), path)

pkg_path()
```

## Arguments

- golem_wd:

  Path to use to read the DESCRIPTION

- path:

  Deprecated, use golem_wd instead

## Value

The value of the entry in the DESCRIPTION file
