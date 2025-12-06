# Add a favicon to your shinyapp

This function adds the favicon from `ico` to your shiny app.

## Usage

``` r
use_favicon(path, golem_wd = get_golem_wd(), method = "curl", pkg)

remove_favicon(path = "inst/app/www/favicon.ico")

favicon(
  ico = "favicon",
  rel = "shortcut icon",
  resources_path = "www",
  ext = "ico"
)
```

## Arguments

- path:

  Path to your favicon file (.ico or .png)

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- method:

  Method to be used for downloading files, 'curl' is default see
  [`utils::download.file()`](https://rdrr.io/r/utils/download.file.html).

- pkg:

  Deprecated, please use golem_wd instead

- ico:

  path to favicon file

- rel:

  rel

- resources_path:

  prefix of the resource path of the app

- ext:

  the extension of the favicon

## Value

Used for side-effects.

An HTML tag.

## Examples

``` r
if (interactive()) {
  use_favicon()
  use_favicon(path = "path/to/your/favicon.ico")
}
```
