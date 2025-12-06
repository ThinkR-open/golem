# Generate a README.Rmd

Generate a README.Rmd

## Usage

``` r
use_readme_rmd(
  open = rlang::is_interactive(),
  pkg_name = golem::get_golem_name(),
  overwrite = FALSE,
  golem_wd = golem::get_golem_wd(),
  pkg
)
```

## Arguments

- open:

  Open the newly created file for editing? Happens in RStudio, if
  applicable, or via
  [`utils::file.edit()`](https://rdrr.io/r/utils/file.edit.html)
  otherwise.

- pkg_name:

  The name of the package

- overwrite:

  an optional `logical` flag; if `TRUE`, overwrite existing
  `README.Rmd`, else throws an error if `README.Rmd` exists

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- pkg:

  Deprecated, please use golem_wd instead

## Value

pure side-effect function that generates template `README.Rmd`
