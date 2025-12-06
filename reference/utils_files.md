# Use the utils files

- use_utils_ui:

  Copies the golem_utils_ui.R to the R folder.

- use_utils_server:

  Copies the golem_utils_server.R to the R folder.

## Usage

``` r
use_utils_ui(golem_wd = get_golem_wd(), with_test = FALSE, pkg)

use_utils_test_ui(golem_wd = get_golem_wd(), pkg)

use_utils_server(golem_wd = get_golem_wd(), with_test = FALSE, pkg)

use_utils_test_ui(golem_wd = get_golem_wd(), pkg)

use_utils_test_server(golem_wd = get_golem_wd(), pkg)
```

## Arguments

- golem_wd:

  Path to the root of the package. Default is
  [`get_golem_wd()`](https://thinkr-open.github.io/golem/reference/golem_opts.md).

- with_test:

  should the module be created with tests?

- pkg:

  Deprecated, please use golem_wd instead

## Value

Used for side-effects.
