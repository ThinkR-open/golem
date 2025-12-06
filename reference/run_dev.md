# Run the `dev/run_dev.R` file

The default `file="dev/run_dev.R"` launches your `{golem}` app with a
bunch of useful options. The file content can be customized and
`file`-name and path changed as long as the argument combination of
`file` and `pkg` are supplied correctly: the `file`-path is a relative
path to a `{golem}`-package root `pkg`. An error is thrown if `pkg/file`
cannot be found.

## Usage

``` r
run_dev(
  file = "dev/run_dev.R",
  golem_wd = get_golem_wd(),
  save_all = TRUE,
  install_required_packages = TRUE,
  pkg
)
```

## Arguments

- file:

  String with (relative) file path to a `run_dev.R`-file

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- save_all:

  Boolean; if `TRUE` saves all open files before sourcing `file`

- install_required_packages:

  Boolean; if `TRUE` install the packages used in `run_dev.R`-file

- pkg:

  Deprecated, please use golem_wd instead

## Value

pure side-effect function; returns invisibly

## Details

The function `run_dev()` is typically used to launch a shiny app by
sourcing the content of an appropriate `run_dev`-file. Carefully read
the content of `dev/run_dev.R` when creating your custom `run_dev`-file.
It has already many useful settings including a switch between
production/development, reloading the package in a clean `R` environment
before running the app etc.
