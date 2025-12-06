# Add recommended elements

- use_recommended_deps:

  Adds `shiny`, `DT`, `attempt`, `glue`, `golem`, `htmltools` to
  dependencies

- use_recommended_tests:

  Adds a test folder and copy the golem tests

## Usage

``` r
use_recommended_deps(
  pkg = get_golem_wd(),
  recommended = c("shiny", "DT", "attempt", "glue", "htmltools", "golem")
)

use_recommended_tests(
  golem_wd = get_golem_wd(),
  spellcheck = TRUE,
  vignettes = TRUE,
  lang = "en-US",
  error = FALSE,
  pkg
)
```

## Arguments

- pkg:

  Deprecated, please use golem_wd instead

- recommended:

  A vector of recommended packages.

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- spellcheck:

  Whether or not to use a spellcheck test.

- vignettes:

  Logical, `TRUE` to spell check all `rmd` and `rnw` files in the
  `vignettes/` folder.

- lang:

  Preferred spelling language. Usually either `"en-US"` or `"en-GB"`.

- error:

  Logical, indicating whether the unit test should fail if spelling
  errors are found. Defaults to `FALSE`, which does not error, but
  prints potential spelling errors

## Value

Used for side-effects.
