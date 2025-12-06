# Add an `app.R` at the root of your package to deploy on RStudio Connect

Additionally, adds a `.rscignore` at the root of the `{golem}` project
if the `rsconnect` package version is `>= 0.8.25`.

## Usage

``` r
add_positconnect_file(golem_wd = get_golem_wd(), open = TRUE, pkg)

add_rstudioconnect_file(golem_wd = get_golem_wd(), open = TRUE, pkg)

add_shinyappsio_file(golem_wd = get_golem_wd(), open = TRUE, pkg)

add_shinyserver_file(golem_wd = get_golem_wd(), open = TRUE, pkg)

add_rscignore_file(golem_wd = get_golem_wd(), open = TRUE, pkg)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- open:

  Should the created file be opened?

- pkg:

  Deprecated, please use golem_wd instead

## Value

Side-effect functions for file creation returning the path to the file,
invisibly.

## Note

In previous versions, this function was called add_rconnect_file.

`add_rstudioconnect_file` is now deprecated; replace by
`add_positconnect_file()`.

## List of excluded files in `.rscignore`

- .here

- CODE_OF_CONDUCT.md

- LICENSE{.md}

- LICENCE{.md}

- NEWS{.md}

- README{.md,.Rmd,.HTML}

- dev

- man

- tests

- vignettes

## Examples

``` r
# Add a file for Connect
if (interactive()) {
  add_positconnect_file()
}
# Add a file for Shiny Server
if (interactive()) {
  add_shinyserver_file()
}
# Add a file for Shinyapps.io
if (interactive()) {
  add_shinyappsio_file()
}
```
