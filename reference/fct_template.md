# Golem Function Template

Function templates can be used to extend the
[`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
creation mechanism with your own template, so that you can be even more
productive when building your `{shiny}` app. Function template functions
do not aim at being called as is by users, but to be passed as an
argument to the
[`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md)
function.

## Usage

``` r
fct_template(name, path, export = FALSE, ...)
```

## Arguments

- name:

  The name of the generated function.

- path:

  The path to the R script where the function will be written. Note that
  this path will not be set by the user but via
  [`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md).

- export:

  Whether the generated function should be exported.

- ...:

  Extra arguments, ignored by the default template.

## Value

Used for side effect

## Details

A template function can take the following arguments to be passed from
[`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md):

- name: the name of the function

- path: the path to the file in R/

- export: a TRUE/FALSE value

If you want your function to ignore these parameters, set `...` as the
last argument of your function, then these will be ignored. See the
examples section of this help.

## See also

[`add_fct()`](https://thinkr-open.github.io/golem/reference/file_creation.md)

## Examples

``` r
if (interactive()) {
  my_tmpl <- function(name, path, ...) {
    # Define a template that writes to the function file
    write(name, path)
  }
  golem::add_fct(name = "custom", template = my_tmpl)
}
```
