# Check App

You are helping a user check their golem Shiny application for errors and warnings.

## Running R CMD Check

Run the following command to check the package:

```r
Rscript -e "devtools::check()"
```

## What Gets Checked

- Package structure and metadata
- Documentation completeness
- Namespace conflicts
- Code quality warnings
- Package dependencies

## Common Issues to Address

### Undocumented functions
- Add roxygen2 comments with `#' @export` or `#' @noRd`
- Run `devtools::document()` to regenerate NAMESPACE and .Rd files

### Missing imports
- Add `@importFrom package function` to roxygen comments
- Or add `usethis::use_package("package")` for Imports in DESCRIPTION

### Undefined global variables
- Use `utils::globalVariables()` if variables are defined dynamically
- Or ensure all variables are properly scoped

### Non-ASCII characters
- Either avoid them in R/ files
- Or add `tools/check.env` with `_R_CHECK_ASCII_CODE_=FALSE`

## Before Committing

Always run `devtools::check()`:
- No errors should be present
- Warnings should be investigated
- Notes should be understood and approved

## Continuous Integration

For automated checking:
- Use GitHub Actions with `r-lib/actions/check-r-package@v2`
- Or set up other CI pipelines that run `devtools::check()`
