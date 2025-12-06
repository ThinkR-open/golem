# Test helpers

These functions are designed to be used inside the tests in your Shiny
app package.

## Usage

``` r
expect_shinytag(object)

expect_shinytaglist(object)

expect_html_equal(ui, html, ...)

expect_running(sleep, R_path = NULL)
```

## Arguments

- object:

  the object to test

- ui:

  output of an UI function

- html:

  deprecated

- ...:

  arguments passed to
  [`testthat::expect_snapshot()`](https://testthat.r-lib.org/reference/expect_snapshot.html)

- sleep:

  number of seconds

- R_path:

  path to R. If NULL, the function will try to guess where R is.

## Value

A testthat result.
