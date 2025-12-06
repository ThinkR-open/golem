# `{golem}` options

Set and get a series of options to be used with `{golem}`. These options
are found inside the `golem-config.yml` file, found in most cases inside
the `inst` folder.

## Usage

``` r
get_golem_wd(use_parent = TRUE, golem_wd = golem::pkg_path(), pkg)

get_golem_name(
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE,
  golem_wd = golem::pkg_path(),
  pkg
)

get_golem_version(
  config = Sys.getenv("GOLEM_CONFIG_ACTIVE", Sys.getenv("R_CONFIG_ACTIVE", "default")),
  use_parent = TRUE,
  golem_wd = golem::pkg_path(),
  pkg
)

set_golem_wd(
  new_golem_wd = golem::pkg_path(),
  current_golem_wd = golem::pkg_path(),
  talkative = TRUE,
  golem_wd,
  pkg
)

set_golem_name(
  name = golem::pkg_name(),
  golem_wd = golem::pkg_path(),
  talkative = TRUE,
  old_name = golem::pkg_name(),
  pkg
)

set_golem_version(
  version = golem::pkg_version(),
  golem_wd = golem::pkg_path(),
  talkative = TRUE,
  pkg
)

set_golem_options(
  golem_name = golem::pkg_name(),
  golem_version = golem::pkg_version(),
  golem_wd = golem::pkg_path(),
  app_prod = FALSE,
  talkative = TRUE,
  config_file = golem::get_current_config(golem_wd)
)
```

## Arguments

- use_parent:

  `TRUE` to scan parent directories for configuration files if the
  specified config file isn't found.

- golem_wd:

  Working directory of the current golem package.

- pkg:

  The path to set the golem working directory. Note that it will be
  passed to `normalizePath`.

- config:

  Name of configuration to read from. Defaults to the value of the
  `R_CONFIG_ACTIVE` environment variable ("default" if the variable does
  not exist).

- new_golem_wd, current_golem_wd:

  New & current directory, to be used in `set_golem_wd()`

- talkative:

  Should the messages be printed to the console?

- name:

  The name of the app

- old_name:

  The old name of the app, used when changing the name

- version:

  The version of the app

- golem_name:

  Name of the current golem.

- golem_version:

  Version of the current golem.

- app_prod:

  Is the `{golem}` in prod mode?

- config_file:

  path to the `{golem}` config file

## Value

Used for side-effects for the setters, and values from the config in the
getters.

## Set Functions

- `set_golem_options()` sets all the options, with the defaults from the
  functions below.

- `set_golem_wd()` defaults to `golem::golem_wd()`, which is the package
  root when starting a golem.

- `set_golem_name()` defaults
  [`golem::pkg_name()`](https://thinkr-open.github.io/golem/reference/pkg_tools.md)

- `set_golem_version()` defaults
  [`golem::pkg_version()`](https://thinkr-open.github.io/golem/reference/pkg_tools.md)

## Get Functions

Reads the information from `golem-config.yml`

- `get_golem_wd()`

- `get_golem_name()`

- `get_golem_version()`
