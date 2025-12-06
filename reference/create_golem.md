# Create a package for a Shiny App using `{golem}`

Create a package for a Shiny App using `{golem}`

## Usage

``` r
create_golem(
  path,
  check_name = TRUE,
  open = TRUE,
  overwrite = FALSE,
  package_name = basename(normalizePath(path, mustWork = FALSE)),
  without_comments = FALSE,
  project_hook = golem::project_hook,
  with_git = FALSE,
  ...
)
```

## Arguments

- path:

  Name of the folder to create the package in. This will also be used as
  the package name.

- check_name:

  Should we check that the package name is correct according to CRAN
  requirements.

- open:

  Boolean. Open the created project?

- overwrite:

  Boolean. Should the already existing project be deleted and replaced?

- package_name:

  Package name to use. By default, `{golem}` uses `basename(path)`. If
  `path == '.'` & `package_name` is not explicitly set, then
  `basename(getwd())` will be used.

- without_comments:

  Boolean. Start project without `{golem}` comments

- project_hook:

  A function executed as a hook after project creation. Can be used to
  change the default `{golem}` structure. to override the files and
  content. This function is executed just after the project is created.

- with_git:

  Boolean. Initialize git repository

- ...:

  Arguments passed to the
  [`project_hook()`](https://thinkr-open.github.io/golem/reference/project_hook.md)
  function.

## Value

The path, invisibly.

## Note

For compatibility issue, this function turns `options(shiny.autoload.r)`
to `FALSE`. See https://github.com/ThinkR-open/golem/issues/468 for more
background.
