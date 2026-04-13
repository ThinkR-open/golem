# 05. Configuration

``` r
library(golem)
```

## Two Ways to Manage Production vs Development Mode

[golem](https://thinkr-open.github.io/golem/) provides two separate
mechanisms for managing production and development modes in your Shiny
applications:

1.  **R Options Approach**: Using `options(golem.app.prod = TRUE/FALSE)`
    which is checked by
    [`app_prod()`](https://thinkr-open.github.io/golem/reference/prod.md)
    and
    [`app_dev()`](https://thinkr-open.github.io/golem/reference/prod.md)
    functions. This approach controls the behavior of
    [golem](https://thinkr-open.github.io/golem/)’s development-aware
    utility functions like
    [`cat_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
    [`print_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
    [`message_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
    and similar tools.

2.  **Configuration File Approach**: Using the `golem-config.yml` file
    to store configuration values (including an `app_prod` setting) that
    can be retrieved in your application code using
    `get_golem_config()`.

**Important**: These two mechanisms are independent and serve different
purposes. The R option controls
[golem](https://thinkr-open.github.io/golem/)’s built-in development
tools, while the config file provides a flexible way to store and
retrieve application-specific settings. This vignette focuses on the
configuration file approach.

## About `inst/golem-config.yml`

When you start a new [golem](https://thinkr-open.github.io/golem/)
application, you’ll find a file called `golem-config.yml` in the `inst/`
folder.

By default, this file contains the name of your app, its version, and
the default working directory (which is the root of your package).

This config file is based on the
[`{config}`](https://github.com/rstudio/config) format, which allows you
to create configuration files for different application contexts. Please
refer to this package documentation for more information.

## Setting `golem-config`

Here is what the default config file looks like:

    default:
      golem_name: golex
      golem_version: 0.0.0.9000
      app_prod: no

    production:
      app_prod: yes

    dev:
      golem_wd: !expr golem::pkg_path()

- default/golem_name, default/golem_version, default/app_prod can be
  used across the whole life of your
  [golem](https://thinkr-open.github.io/golem/) app: while developing,
  and also when in production.
- production/app_prod can be used to add elements that are to be used
  once the app is in production.
- dev/golem_wd is in a `dev` config because the only moment you might
  reliably use this config is while developing your app. Use the
  `app_sys()` function if you want to rely on the package path once the
  app is deployed.

The good news is that if you don’t want/need to use
[config](https://rstudio.github.io/config/), you can safely ignore this
file, **just leave it where it is: it is used internally by the
[golem](https://thinkr-open.github.io/golem/) functions**.

These options are globally set with:

``` r
set_golem_options()
#> ── Setting {golem} options in `golem-config.yml` ───────────────────────────────
#> ✔ Setting `golem_name` to golex
#> ✔ Setting `golem_wd` to golem::pkg_path()
#> You can change golem working directory with set_golem_wd('path/to/wd')
#> ✔ Setting `golem_version` to 0.0.0.9000
#> ✔ Setting `app_prod` to FALSE
#> ── Setting {usethis} project as `golem_wd` ─────────────────────────────────────
#> ✔ Setting active project to "/tmp/Rtmp2BJQwf/golex".
```

    default:
      golem_name: golex
      golem_version: 0.0.0.9000
      app_prod: no
    production:
      app_prod: yes
    dev:
      golem_wd: !expr golem::pkg_path()

The functions reading the options in this config file are:

``` r
get_golem_name()
#> [1] "golex"
get_golem_wd()
#> [1] "/tmp/Rtmp2BJQwf/golex"
get_golem_version()
#> [1] "0.0.0.9000"
```

You can set these with:

``` r
set_golem_name("this")
set_golem_wd(".")
set_golem_version("0.0.1")
```

    default:
      golem_name: golex
      golem_version: 0.0.0.9000
      app_prod: no
    production:
      app_prod: yes
    dev:
      golem_wd: !expr golem::pkg_path()

## Using `golem-config`

If you’re already familiar with the
[config](https://rstudio.github.io/config/) package, you can use this
file just as any config file.

[golem](https://thinkr-open.github.io/golem/) comes with an
[`amend_golem_config()`](https://thinkr-open.github.io/golem/reference/amend_golem_config.md)
function to add elements to it.

``` r
amend_golem_config(
  key = "where",
  value = "indev"
)
#> ✔ Setting `where` to indev
amend_golem_config(
  key = "where",
  value = "inprod",
  config = "production"
)
#> ✔ Setting `where` to inprod
```

Will result in a `golem-config.yml` file as such:

    default:
      golem_name: golex
      golem_version: 0.0.0.9000
      app_prod: no
      where: indev
    production:
      app_prod: yes
      where: inprod
    dev:
      golem_wd: !expr golem::pkg_path()

## `app_config.R`

In `R/app_config.R`, you’ll find a `get_golem_config()` function that
allows you to retrieve config from this config file:

``` r
pkgload::load_all()
#> ℹ Loading golex
get_golem_config(
  "where"
)
#> [1] "indev"
get_golem_config(
  "where",
  config = "production"
)
#> [1] "inprod"
```

Or using the env var (default
[config](https://rstudio.github.io/config/) behavior):

``` r
Sys.setenv("R_CONFIG_ACTIVE" = "production")
get_golem_config("where")
#> [1] "inprod"
```

## `golem_config` vs `golem_options`

There are two ways to configure golem apps:

- The `golem_opts` in the `run_app()` function
- The `golem-config.yml` file

The main difference between these two is that the
[golem](https://thinkr-open.github.io/golem/) options from `run_app()`
are meant to be configured during runtime: you’ll be doing
`run_app(val = "this")`, whereas the `golem-config` is meant to be used
in the backend, and will not be linked to the parameters passed to
`run_app()` (even if this is technically possible, this is not the main
objective).

The `golem-config.yml` file is also linked to the `R_CONFIG_ACTIVE`
environment variable, just as any
[config](https://rstudio.github.io/config/) file.

Additionally, the `golem-config.yml` file is shareable across
[golem](https://thinkr-open.github.io/golem/) projects (whereas
`golem_opts` are application specific), and will be tracked by version
control systems.

## Connecting Back to the R Options Approach

As mentioned at the beginning of this vignette,
[golem](https://thinkr-open.github.io/golem/) uses two separate
mechanisms for production/development configuration. While this vignette
has focused on the `golem-config.yml` file, it’s important to understand
how this relates to the R options approach.

### The R Options Mechanism

The R option `options(golem.app.prod)` is used by
[golem](https://thinkr-open.github.io/golem/)’s development-aware
functions:

- [`app_prod()`](https://thinkr-open.github.io/golem/reference/prod.md) -
  Returns `TRUE` if the app is in production mode
- [`app_dev()`](https://thinkr-open.github.io/golem/reference/prod.md) -
  Returns `TRUE` if the app is in development mode
- Development-only output functions:
  [`cat_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
  [`print_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
  [`message_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
  [`warning_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md),
  [`browser_dev()`](https://thinkr-open.github.io/golem/reference/made_dev.md)

These functions check `getOption("golem.app.prod")` directly and do not
read from the config file.

### Important: The Two Mechanisms Are Independent

The `app_prod` value in `golem-config.yml` and the
`options(golem.app.prod)` R option are **not automatically
synchronized**. They serve different purposes:

- **Config file `app_prod`**: A persistent configuration value that you
  can retrieve using `get_golem_config("app_prod")` to use in your own
  application logic. This value can vary by environment (default,
  production, dev) using the `R_CONFIG_ACTIVE` environment variable.

- **R option `golem.app.prod`**: A session-level setting that controls
  [golem](https://thinkr-open.github.io/golem/)’s built-in development
  tools. This must be explicitly set in your code or launch
  configuration (e.g., in Docker CMD or `run_dev.R`).

### Best Practices

- **Set the R option explicitly**: When deploying to production, ensure
  you set `options(golem.app.prod = TRUE)` in your app’s launch script
  or Docker configuration. The
  [golem](https://thinkr-open.github.io/golem/) Dockerfile templates
  handle this automatically.

- **Use the config file for your app’s logic**: If you need
  environment-specific configuration in your application code (e.g.,
  different API endpoints for dev vs production), use
  `get_golem_config()` to retrieve values from `golem-config.yml`.

- **Keep them in sync if needed**: If you want the config file’s
  `app_prod` setting to match your R option, you’ll need to manage this
  synchronization in your own code. For example, in your `run_app()`
  function, you could set the option based on the config value:

``` r
# Example: sync config to R option (optional)
if (get_golem_config("app_prod")) {
  options(golem.app.prod = TRUE)
}
```

## Note for `{golem}` \< 0.2.0 users

If you’ve built an app with
[golem](https://thinkr-open.github.io/golem/) before the version 0.2.0,
this config file doesn’t exist: you’ll be prompted to create it if you
update a newer version of [golem](https://thinkr-open.github.io/golem/).
