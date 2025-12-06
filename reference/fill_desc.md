# Fill your `DESCRIPTION` file

Generates a standard `DESCRIPTION` file as used in R packages. Also sets
a series of global options inside `golem-config.yml` that will be reused
inside `{golem}` (see `set_options` and
[`set_golem_options()`](https://thinkr-open.github.io/golem/reference/golem_opts.md)
for details).

## Usage

``` r
fill_desc(
  pkg_name,
  pkg_title,
  pkg_description,
  authors = person(given = NULL, family = NULL, email = NULL, role = NULL, comment =
    NULL),
  repo_url = NULL,
  pkg_version = "0.0.0.9000",
  pkg = get_golem_wd(),
  author_first_name = NULL,
  author_last_name = NULL,
  author_email = NULL,
  author_orcid = NULL,
  set_options = TRUE
)
```

## Arguments

- pkg_name:

  The name of the package

- pkg_title:

  The title of the package

- pkg_description:

  Description of the package

- authors:

  a character string (or vector) of class person (see
  [`person()`](https://rdrr.io/r/utils/person.html) for details)

- repo_url:

  URL (if needed)

- pkg_version:

  The version of the package. Default is 0.0.0.9000

- pkg:

  Path to look for the DESCRIPTION. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- author_first_name:

  to be deprecated: use character for first name via
  `authors = person(given = "authors_first_name")` instead

- author_last_name:

  to be deprecated: use character for last name via
  `authors = person(given = "authors_last_name")` instead

- author_email:

  to be deprecated: use character for first name via
  `authors = person(email = "author_email")` instead

- author_orcid:

  to be deprecated

- set_options:

  logical; the default `TRUE` sets all recommended options but this can
  be suppressed with `FALSE`. For details on the exact behaviour see the
  help
  [`set_golem_options()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

## Value

The `{desc}` object, invisibly.
