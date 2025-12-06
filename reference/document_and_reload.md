# Document and reload your package

This function calls
[`rstudioapi::documentSaveAll()`](https://rstudio.github.io/rstudioapi/reference/rstudio-documents.html),
[`roxygen2::roxygenise()`](https://roxygen2.r-lib.org/reference/roxygenize.html)
and
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html).

## Usage

``` r
document_and_reload(
  golem_wd = get_golem_wd(),
  roclets = NULL,
  load_code = NULL,
  clean = FALSE,
  export_all = FALSE,
  helpers = FALSE,
  attach_testthat = FALSE,
  ...,
  pkg
)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- roclets:

  Character vector of roclet names to use with package. The default,
  `NULL`, uses the roxygen `roclets` option, which defaults to
  `c("collate", "namespace", "rd")`.

- load_code:

  A function used to load all the R code in the package directory. The
  default, `NULL`, uses the strategy defined by the `load` roxygen
  option, which defaults to
  [`load_pkgload()`](https://roxygen2.r-lib.org/reference/load.html).
  See [load](https://roxygen2.r-lib.org/reference/load.html) for more
  details.

- clean:

  If `TRUE`, roxygen will delete all files previously created by roxygen
  before running each roclet.

- export_all:

  If `TRUE` (the default), export all objects. If `FALSE`, export only
  the objects that are listed as exports in the NAMESPACE file.

- helpers:

  if `TRUE` loads testthat test helpers.

- attach_testthat:

  If `TRUE`, attach testthat to the search path, which more closely
  mimics the environment within test files.

- ...:

  Other arguments passed to
  [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)

- pkg:

  Deprecated, please use golem_wd instead

## Value

Used for side-effects
