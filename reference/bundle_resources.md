# Automatically serve golem external resources

This function is a wrapper around
[`htmltools::htmlDependency`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
that automatically bundles the CSS and JavaScript files in
`inst/app/www` and which are created by
[`golem::add_css_file()`](https://thinkr-open.github.io/golem/reference/add_files.md)
,
[`golem::add_js_file()`](https://thinkr-open.github.io/golem/reference/add_files.md)
and
[`golem::add_js_handler()`](https://thinkr-open.github.io/golem/reference/add_files.md).

## Usage

``` r
bundle_resources(
  path,
  app_title,
  name = "golem_resources",
  version = "0.0.1",
  meta = NULL,
  head = NULL,
  attachment = NULL,
  package = NULL,
  all_files = TRUE,
  app_builder = "golem",
  with_sparkles = FALSE,
  activate_js = TRUE
)
```

## Arguments

- path:

  The path to the folder where the external files are located.

- app_title:

  The title of the app, to be used as an application title.

- name:

  Library name

- version:

  Library version

- meta:

  Named list of meta tags to insert into document head

- head:

  Arbitrary lines of HTML to insert into the document head

- attachment:

  Attachment(s) to include within the document head. See Details.

- package:

  An R package name to indicate where to find the `src` directory when
  `src` is a relative path (see
  [`resolveDependencies()`](https://rstudio.github.io/htmltools/reference/resolveDependencies.html)).

- all_files:

  Whether all files under the `src` directory are dependency files. If
  `FALSE`, only the files specified in `script`, `stylesheet`, and
  `attachment` are treated as dependency files.

- app_builder:

  The name of the app builder to add as a meta tag. Turn to NULL if you
  don't want this meta tag to be included.

- with_sparkles:

  C'est quand que tu vas mettre des paillettes dans ma vie Kevin?

- activate_js:

  Boolean to enable or disable the injection of JavaScript via
  activate_js().

## Value

an htmlDependency

## Details

This function also preload
[`activate_js()`](https://thinkr-open.github.io/golem/reference/golem_js.md)
which allows to use preconfigured JavaScript functions via
[`invoke_js()`](https://thinkr-open.github.io/golem/reference/golem_js.md).
