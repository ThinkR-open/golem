---
name: golem-add-function
description: |
  Add functions to a golem Shiny application.
  Triggers on:
    - "add a function"
    - "create a helper function"
    - "add a utility function"
  Do not trigger on:
    - when the user is not working inside a golem app
---

# Add Function

You are helping a user add functions to their golem Shiny application.

## Creating Functions

Use the appropriate `golem::add_*()` function based on where the code belongs:

- `golem::add_fct("name", with_test = TRUE)` - Business logic and factory functions
- `golem::add_utils("name", with_test = TRUE)` - Utility functions

## Function Types

### Factory Functions (`R/fct_*.R`)

- Contain business logic that can be reused
- Should be testable in isolation, outside of Shiny context
- Example: data processing, calculations, validations
- Created with `golem::add_fct()`

### Utility Functions (`R/utils_*.R`)

- General-purpose helpers
- Reusable across modules
- Can be utility functions for modules: `R/mod_<name>_utils_<fn>.R`
- Created with `golem::add_utils()`

## Documentation

All functions MUST be documented with roxygen2.
In almost all cases, the internal functions do no need to be exported.
They are only useful inside the app.
If ever you have a doubt, ask the user.

```r
#' Function Title
#'
#' Function description
#'
#' @param x Parameter description
#'
#' @return What the function returns
#'
#' @examples
#' my_func(x = 1)
#'
#' @importFrom pkg_name func_name
#'
#' @export
my_func <- function(x) {
  # function body
}
```

## Important Rules

- Run `devtools::document()` after adding roxygen comments
- All functions must have `@examples`
- Use `@importFrom` for external package functions
- Use `@noRd` for internal functions (don't document in Rd files)
- Never use `library()`, `require()`, or `source()` inside functions
- Use `@inheritParams` to avoid duplicating parameter docs

## Testing

- Tests should be hermetic - each `test_that()` block sets up its own data
- Test business logic outside of Shiny context when possible
- Use `withr::local_*()` for temporary state changes
- Write temporary files only to `withr::local_tempfile()` or `withr::local_tempdir()`
- Store static test data in `tests/testthat/fixtures/`

## Code Quality

- Follow the tidyverse style guide
- Use `air format .` if installed
- No non-ASCII characters in R/ files (or create `tools/check.env` with `_R_CHECK_ASCII_CODE_=FALSE`)
- Use `TRUE`/`FALSE`, never `T`/`F`
- Never use `=` for assignment, use `<-`
- Avoid modifying global state - use `on.exit(..., add = TRUE)` if necessary
