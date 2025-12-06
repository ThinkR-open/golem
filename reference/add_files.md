# Create Files

These functions create files inside the `inst/app` folder.

## Usage

``` r
add_js_file(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  with_doc_ready = TRUE,
  template = golem::js_template,
  ...,
  pkg
)

add_js_handler(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::js_handler_template,
  ...,
  pkg
)

add_js_input_binding(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  initialize = FALSE,
  dev = FALSE,
  events = list(name = "click", rate_policy = FALSE),
  pkg
)

add_js_output_binding(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  pkg
)

add_css_file(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::css_template,
  ...,
  pkg
)

add_sass_file(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::sass_template,
  ...,
  pkg
)

add_empty_file(
  name,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::empty_template,
  ...,
  pkg
)

add_html_template(
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  pkg
)

add_partial_html_template(
  name = "partial_template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  pkg
)

add_ui_server_files(
  golem_wd = get_golem_wd(),
  dir = "inst/app",
  dir_create,
  pkg
)
```

## Arguments

- name:

  The name of the module.

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- dir:

  Path to the dir where the file while be created.

- open:

  Should the created file be opened?

- dir_create:

  Deprecated. Will be removed in future versions and throws an error for
  now.

- with_doc_ready:

  For JS file - Should the default file include `$( document ).ready()`?

- template:

  Function writing in the created file. You may overwrite this with your
  own template function.

- ...:

  Arguments to be passed to the `template` function.

- pkg:

  Deprecated, please use golem_wd instead

- initialize:

  For JS file - Whether to add the initialize method. Default to FALSE.
  Some JavaScript API require to initialize components before using
  them.

- dev:

  Whether to insert console.log calls in the most important methods of
  the binding. This is only to help building the input binding. Default
  is FALSE.

- events:

  List of events to generate event listeners in the subscribe method.
  For instance,
  `list(name = c("click", "keyup"), rate_policy = c(FALSE, TRUE))`. The
  list contain names and rate policies to apply to each event. If a rate
  policy is found, the debounce method with a default delay of 250 ms is
  applied. You may edit manually according to
  <https://shiny.rstudio.com/articles/building-inputs.html>

## Value

The path to the file, invisibly.

## Note

`add_ui_server_files` will be deprecated in future version of `{golem}`

## See also

[`js_template`](https://thinkr-open.github.io/golem/reference/template.md),
[`js_handler_template`](https://thinkr-open.github.io/golem/reference/template.md),
and
[`css_template`](https://thinkr-open.github.io/golem/reference/template.md)
