# Create a Dockerfile for your App

Build a container containing your Shiny App. `add_dockerfile()` and
`add_dockerfile_with_renv()` and `add_dockerfile_with_renv()` creates a
generic Dockerfile, while `add_dockerfile_shinyproxy()`,
`add_dockerfile_with_renv_shinyproxy()` ,
`add_dockerfile_with_renv_shinyproxy()` and `add_dockerfile_heroku()`
creates platform specific Dockerfile.

## Usage

``` r
add_dockerfile(
  path = "DESCRIPTION",
  output = "Dockerfile",
  golem_wd = get_golem_wd(),
  from = paste0("rocker/verse:", R.Version()$major, ".", R.Version()$minor),
  as = NULL,
  port = 80,
  host = "0.0.0.0",
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL,
  pkg
)

add_dockerfile_shinyproxy(
  path = "DESCRIPTION",
  output = "Dockerfile",
  golem_wd = get_golem_wd(),
  from = paste0("rocker/verse:", R.Version()$major, ".", R.Version()$minor),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL,
  pkg
)

add_dockerfile_heroku(
  path = "DESCRIPTION",
  output = "Dockerfile",
  golem_wd = get_golem_wd(),
  from = paste0("rocker/verse:", R.Version()$major, ".", R.Version()$minor),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL,
  pkg
)

add_dockerfile_with_renv(
  golem_wd = get_golem_wd(),
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  from = "rocker/verse",
  as = "builder",
  sysreqs = TRUE,
  port = 80,
  host = "0.0.0.0",
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  document = TRUE,
  extra_sysreqs = NULL,
  update_tar_gz = TRUE,
  dockerfile_cmd = NULL,
  user = "rstudio",
  single_file = TRUE,
  set_golem.app.prod = TRUE,
  ...,
  source_folder
)

add_dockerfile_with_renv_shinyproxy(
  golem_wd = get_golem_wd(),
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  from = "rocker/verse",
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  open = TRUE,
  document = TRUE,
  update_tar_gz = TRUE,
  user = "rstudio",
  single_file = TRUE,
  set_golem.app.prod = TRUE,
  ...,
  source_folder
)

add_dockerfile_with_renv_heroku(
  golem_wd = get_golem_wd(),
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  from = "rocker/verse",
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  open = TRUE,
  document = TRUE,
  user = "rstudio",
  update_tar_gz = TRUE,
  single_file = TRUE,
  set_golem.app.prod = TRUE,
  ...,
  source_folder
)
```

## Arguments

- path:

  path to the DESCRIPTION file to use as an input.

- output:

  name of the Dockerfile output.

- golem_wd:

  path to the Package/golem source folder to deploy. default is
  retrieved via
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- from:

  The FROM of the Dockerfile. Default is

      FROM rocker/verse

      without renv.lock file passed
      `R.Version()$major`.`R.Version()$minor` is used as tag

- as:

  The AS of the Dockerfile. Default it NULL.

- port:

  The `options('shiny.port')` on which to run the App. Default is 80.

- host:

  The `options('shiny.host')` on which to run the App. Default is
  0.0.0.0.

- sysreqs:

  boolean. If TRUE, RUN statements to install packages system
  requirements will be included in the Dockerfile.

- repos:

  character. The URL(s) of the repositories to use for
  `options("repos")`.

- expand:

  boolean. If `TRUE` each system requirement will have its own `RUN`
  line.

- open:

  boolean. Should the Dockerfile/README/README be open after creation?
  Default is `TRUE`.

- update_tar_gz:

  boolean. If `TRUE` and `build_golem_from_source` is also `TRUE`, an
  updated tar.gz is created.

- build_golem_from_source:

  boolean. If `TRUE` no tar.gz is created and the Dockerfile directly
  mount the source folder.

- extra_sysreqs:

  character vector. Extra debian system requirements.

- pkg:

  Deprecated, please use golem_wd instead

- lockfile:

  path to the renv.lock file to use. default is `NULL`.

- output_dir:

  folder to export everything deployment related.

- distro:

  One of "focal", "bionic", "xenial", "centos7", or "centos8". See
  available distributions at https://hub.docker.com/r/rstudio/r-base/.

- document:

  boolean. If TRUE (by default), DESCRIPTION file is updated using
  [`attachment::att_amend_desc()`](https://thinkr-open.github.io/attachment/reference/att_amend_desc.html)
  before creating the renv.lock file

- dockerfile_cmd:

  What is the CMD to add to the Dockerfile. If NULL, the default, the
  CMD will be
  `R -e "options('shiny.port'={port},shiny.host='{host}',golem.app.prod = {set_golem.app.prod});library({appname});{appname}::run_app()\`.

- user:

  Name of the user to specify in the Dockerfile with the USER
  instruction. Default is `rstudio`, if set to `NULL` no the user from
  the FROM image is used.

- single_file:

  boolean. If `TRUE` (by default), generate a single multi-stage
  Dockerfile . If `FALSE`, produce two distinct Dockerfiles to be run
  sequentially for the build and production phases.

- set_golem.app.prod:

  boolean If `TRUE` (by default) set options(golem.app.prod = TRUE) in
  dockerfile_cmd.

- ...:

  Other arguments to pass to
  [`renv::snapshot()`](https://rstudio.github.io/renv/reference/snapshot.html).

- source_folder:

  deprecated, use golem_wd instead

## Value

The `{dockerfiler}` object, invisibly.

## Examples

``` r
# \donttest{
# Add a standard Dockerfile
if (interactive() & requireNamespace("dockerfiler")) {
  add_dockerfile()
}
#> Loading required namespace: dockerfiler
# Crete a 'deploy' folder containing everything needed to deploy
# the golem using docker based on {renv}
if (interactive() & requireNamespace("dockerfiler")) {
  add_dockerfile_with_renv(
    # lockfile = "renv.lock", # uncomment to use existing renv.lock file
    output_dir = "deploy"
  )
}
# Add a Dockerfile for ShinyProxy
if (interactive() & requireNamespace("dockerfiler")) {
  add_dockerfile_shinyproxy()
}

# Crete a 'deploy' folder containing everything needed to deploy
# the golem with ShinyProxy using docker based on {renv}
if (interactive() & requireNamespace("dockerfiler")) {
  add_dockerfile_with_renv(
    # lockfile = "renv.lock",# uncomment to use existing renv.lock file
    output_dir = "deploy"
  )
}

# Add a Dockerfile for Heroku
if (interactive() & requireNamespace("dockerfiler")) {
  add_dockerfile_heroku()
}
# }
```
