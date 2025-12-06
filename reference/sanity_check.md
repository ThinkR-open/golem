# Sanity check for R files in the project

This function is used check for any \`browser()“ or commented \#TODO /
\#TOFIX / \#BUG in the code

## Usage

``` r
sanity_check(golem_wd = get_golem_wd(), pkg)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- pkg:

  Deprecated, please use golem_wd instead

## Value

A DataFrame if any of the words has been found.
