# Add recommended elements

Add recommended elements

## Usage

``` r
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

- pkg:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

Used for side-effects.
