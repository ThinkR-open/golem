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
  pkg
)

use_external_css_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_external_html_template(
  url,
  name = "template.html",
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
)

use_external_file(
  url,
  name = NULL,
  golem_wd = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create,
  pkg
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

  Deprecated, please use golem_wd instead

- path:

  String representation of the local path for the file to be implemented
  (use_file only)

## Value

The path to the file, invisibly.

## Note

See
[`?htmltools::htmlTemplate`](https://rstudio.github.io/htmltools/reference/htmlTemplate.html)
and `https://shiny.rstudio.com/articles/templates.html` for more
information about `htmlTemplate`.
