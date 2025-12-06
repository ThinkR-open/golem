# 05. Configuration

``` r
library(golem)
```

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

- default/golem_name, default/golem_version, default/app_prod are usable
  across the whole life of your golem app: while developing, and also
  when in production.
- production/app_prod might be used for adding elements that are to be
  used once the app is in production.
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
#> ✔ Setting active project to "/tmp/RtmpmkgxOP/golex".
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
#> [1] "/tmp/RtmpmkgxOP/golex"
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

There is two ways to configure golem apps:

- The `golem_opts` in the `run_app()` function
- The `golem-config.yml` file

The big difference between these two is that the golem options from
`run_app()` are meant to be configured during runtime: you’ll be doing
`run_app(val = "this")`, whereas the `golem-config` is meant to be used
in the back-end, and will not be linked to the parameters passed to
`run_app()` (even if this is technically possible, this is not the main
objective),.

It’s also linked to the `R_CONFIG_ACTIVE` environment variable, just as
any [config](https://rstudio.github.io/config/) file.

The idea is also that the `golem-config.yml` file is shareable across
[golem](https://thinkr-open.github.io/golem/) projects (`golem_opts` are
application specific), and will be tracked by version control systems.

## Note for `{golem}` \< 0.2.0 users

If you’ve built an app with
[golem](https://thinkr-open.github.io/golem/) before the version 0.2.0,
this config file doesn’t exist: you’ll be prompted to create it if you
update a newer version of [golem](https://thinkr-open.github.io/golem/).
