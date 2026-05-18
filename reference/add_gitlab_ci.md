# Add deployment CI for GitLab

Creates a minimal GitLab CI file for deploying a `{golem}` app to Posit
Connect via `{rsconnect}`. If needed, this function also creates a root
`app.R` and `.rscignore` by calling
[`add_positconnect_file()`](https://thinkr-open.github.io/golem/reference/rstudio_deploy.md).
The generated Posit Connect entrypoint uses `{pkgload}`, so `{pkgload}`
is added to `DESCRIPTION`.

## Usage

``` r
add_gitlab_ci(golem_wd = get_golem_wd(), open = TRUE)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- open:

  Should the created file be opened?

## Value

The path to the created GitLab CI file, invisibly.
