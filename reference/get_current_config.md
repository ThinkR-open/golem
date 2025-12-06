# Return path to the `{golem}` config-file

This function tries to find the current config file, being either
inst/golem-config.yml or the GOLEM_CONFIG_PATH env var

## Usage

``` r
get_current_config(path = getwd())
```

## Arguments

- path:

  character string giving the path to start looking for the config; the
  usual value is the `{golem}`-package top-level directory but a user
  supplied config is now supported (see **Details** for how to use this
  feature).

## Value

character string giving the path to the `{golem}` config-file

## Details

In most cases this function simply returns the path to the default
golem-config file located under "inst/golem-config.yml". That config
comes in `yml`-format, see the [Engineering Production-Grade Shiny
Apps](https://engineering-shiny.org/golem.html?q=config#golem-config)
for further details on its format and how to set options therein.

Advanced app developers may benefit from having an additional user
config-file. This is achieved with setting the GOLEM_CONFIG_PATH env
var.
