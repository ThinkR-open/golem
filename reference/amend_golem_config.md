# Amend golem config file

Amend golem config file

## Usage

``` r
amend_golem_config(
  key,
  value,
  config = "default",
  golem_wd = golem::pkg_path(),
  talkative = TRUE,
  pkg
)
```

## Arguments

- key:

  key of the value to add in `config`

- value:

  Name of value (`NULL` to read all values)

- config:

  Name of configuration to read from. Defaults to the value of the
  `R_CONFIG_ACTIVE` environment variable ("default" if the variable does
  not exist).

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- talkative:

  Should the messages be printed to the console?

- pkg:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

Used for side effects.
