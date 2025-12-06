# Golem Module Template Function

Module template can be used to extend golem module creation mechanism
with your own template, so that you can be even more productive when
building your `{shiny}` app. Module template functions do not aim at
being called as is by users, but to be passed as an argument to the
[`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md)
function.

## Usage

``` r
module_template(name, path, export, ph_ui = " ", ph_server = " ", ...)
```

## Arguments

- name:

  The name of the module.

- path:

  The path to the R script where the module will be written. Note that
  this path will not be set by the user but via
  [`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md).

- export:

  Should the module be exported? Default is `FALSE`.

- ph_ui, ph_server:

  Texts to insert inside the modules UI and server. For advanced use.

- ...:

  Arguments to be passed to the `module_template` function.

## Value

Used for side effect

## Details

Module template functions are a way to define your own template function
for module. A template function that can take the following arguments to
be passed from
[`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md):

- name: the name of the module

- path: the path to the file in R/

- export: a TRUE/FALSE set by the `export` param of
  [`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md)

If you want your function to ignore these parameters, set `...` as the
last argument of your function, then these will be ignored. See the
examples section of this help.

## See also

[`add_module()`](https://thinkr-open.github.io/golem/reference/add_module.md)

## Examples

``` r
if (interactive()) {
  my_tmpl <- function(name, path, ...) {
    # Define a template that write to the
    # module file
    write(name, path)
  }
  golem::add_module(name = "custom", module_template = my_tmpl)

  my_other_tmpl <- function(name, path, ...) {
    # Copy and paste a file from somewhere
    file.copy(..., path)
  }
  golem::add_module(name = "custom", module_template = my_other_tmpl)
}
```
