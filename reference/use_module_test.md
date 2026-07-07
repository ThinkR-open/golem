# Add a test file for a module

Add a test file for in module, with the new testServer structure.

## Usage

``` r
use_module_test(name, golem_wd = get_golem_wd(), open = TRUE, pkg)
```

## Arguments

- name:

  The name of the module.

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- open:

  Should the created file be opened?

- pkg:

  **\[deprecated\]** This argument has been replaced by `golem_wd` and
  is kept here for backward compatibility. Providing a value to this
  argument has no effect: the value is silently ignored, and `golem_wd`
  is used instead.

## Value

Used for side effect. Returns the path invisibly.
