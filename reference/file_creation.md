# Add fct\_ and utils\_ files

These functions add files in the R/ folder that starts either with
`fct_` (short for function) or with `utils_`.

## Usage

``` r
add_fct(
  name,
  module = NULL,
  golem_wd = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE,
  template = fct_template,
  ...,
  pkg
)

add_utils(
  name,
  module = NULL,
  golem_wd = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE,
  pkg
)

add_r6(
  name,
  module = NULL,
  golem_wd = get_golem_wd(),
  open = TRUE,
  dir_create = TRUE,
  with_test = FALSE,
  pkg
)
```

## Arguments

- name:

  The name of the file

- module:

  If not NULL, the file will be module specific in the naming (you don't
  need to add the leading `mod_`).

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- open:

  Should the created file be opened?

- dir_create:

  Creates the directory if it doesn't exist, default is `TRUE`.

- with_test:

  should the module be created with tests?

- template:

  Function writing the default contents of a function file. Defaults to
  the built-in function template. Ignored for module-specific files.

- ...:

  Arguments passed to the `template` function.

- pkg:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

The path to the file, invisibly.
