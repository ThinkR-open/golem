# Golem's default custom templates

These functions do not aim at being called as is by users, but to be
passed as an argument to the
[`add_js_handler()`](https://thinkr-open.github.io/golem/reference/add_files.md)
function.

## Usage

``` r
js_handler_template(path, name = "fun", code = " ")

js_template(path, code = " ")

css_template(path, code = " ")

sass_template(path, code = " ")

empty_template(path, code = " ")
```

## Arguments

- path:

  The path to the JS script where this template will be written.

- name:

  Shiny's custom handler name.

- code:

  JavaScript code to be written in the function.

## Value

Used for side effect

## See also

[`add_js_handler()`](https://thinkr-open.github.io/golem/reference/add_files.md)
