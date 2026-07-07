# Use Files

These functions download files from external sources and put them inside
the `inst/app/www` directory. The `use_internal_` functions will copy
internal files, while `use_external_` will try to download them from a
remote location.

## Usage

``` r
use_external_js_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg,
  replace = FALSE
)

use_external_css_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg,
  replace = FALSE
)

use_external_html_template(
  url,
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  extract = c("ask", "yes", "no"),
  delete_zip = c("ask", "yes", "no"),
  replace = FALSE
)

use_external_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg,
  replace = FALSE
)

use_bundled_html(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  extract = c("ask", "yes", "no"),
  delete_zip = c("ask", "yes", "no"),
  replace = FALSE
)

use_internal_js_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_css_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_html_template(
  path,
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_internal_file(
  path,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)
```

## Arguments

- url:

  String representation of URL for the file to be downloaded

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

  Creates the directory if it doesn't exist, default is `TRUE`.

- pkg:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

- replace:

  Boolean. If `TRUE`, an existing file (or, for `use_bundled_html()`, an
  existing bundle directory) at the target location is overwritten.
  Defaults to `FALSE`, in which case the function aborts if the target
  already exists.

- extract:

  Whether to extract a downloaded HTML zip bundle. Use `"ask"` to
  prompt. Only used by `use_bundled_html()` and by
  `use_external_html_template()` when `url` points to a `.zip` archive.

- delete_zip:

  Whether to delete the raw HTML zip after extraction. Use `"ask"` to
  prompt. Only used by `use_bundled_html()` and by
  `use_external_html_template()` when `url` points to a `.zip` archive.

- path:

  String representation of the local path for the file to be implemented
  (use_file only)

## Value

The path to the file, invisibly.

## Note

See
[`?htmltools::htmlTemplate`](https://rstudio.github.io/htmltools/reference/htmlTemplate.html)
and `https://shiny.posit.co/r/articles/build/templates/` for more
information about `htmlTemplate`.
