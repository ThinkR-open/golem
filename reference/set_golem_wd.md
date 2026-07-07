# Set the golem working directory

Set the `golem_wd` value (the working directory of the current golem
package) inside the `golem-config.yml` file.

## Usage

``` r
set_golem_wd(
  new_golem_wd = golem::pkg_path(),
  current_golem_wd = golem::pkg_path(),
  talkative = TRUE,
  golem_wd,
  pkg
)
```

## Arguments

- new_golem_wd, current_golem_wd:

  New & current directory, to be used in `set_golem_wd()`.

- talkative:

  Should the messages be printed to the console?

- golem_wd:

  **\[deprecated\]** This argument has been replaced by `new_golem_wd`
  and is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and
  `new_golem_wd` is used instead.

- pkg:

  **\[deprecated\]** This argument has been replaced by
  `current_golem_wd` and is kept here for backward compatibility.
  Providing a value to this argument has no effect: the value is
  silently ignored, and `current_golem_wd` is used instead.

## Value

Used for side-effects, and returns the `golem_wd` path invisibly.
