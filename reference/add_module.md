# Create a module

This function creates a module inside the `R/` folder, based on a
specific module structure. This function can be used outside of a
`{golem}` project.

## Usage

``` r
add_module(
  name,
  golem_wd = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  fct = NULL,
  utils = NULL,
  r6 = NULL,
  js = NULL,
  js_handler = NULL,
  export = FALSE,
  module_template = golem::module_template,
  with_test = FALSE,
  ...,
  pkg
)
```

## Arguments

- name:

  The name of the module.

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- open:

  Should the created file be opened?

- dir_create:

  Creates the directory if it doesn't exist, default is `TRUE`.

- fct:

  If specified, creates a `mod_fct` file.

- utils:

  If specified, creates a `mod_utils` file.

- r6:

  If specified, creates a `mod_class` file.

- js, js_handler:

  If specified, creates a module related JavaScript file.

- export:

  Should the module be exported? Default is `FALSE`.

- module_template:

  Function that serves as a module template.

- with_test:

  should the module be created with tests?

- ...:

  Arguments to be passed to the `module_template` function.

- pkg:

  Deprecated, please use golem_wd instead

## Value

The path to the file, invisibly.

## Note

This function will prefix the `name` argument with `mod_`.

## See also

[`module_template()`](https://thinkr-open.github.io/golem/reference/module_template.md)
