---
name: golem-run-tests
description: |
  Run tests for a golem Shiny application.
  Triggers on:
    - "run the tests"
    - "test my golem app"
    - "run devtools test"
  Do not trigger on:
    - when the user is not working inside a golem app
---

# Run Tests

You are helping a user run tests for their golem Shiny application.

## Running Tests

Run the following command to execute all tests:

```r
Rscript -e "devtools::test()"
```

## Testing Structure

Tests are organized in `tests/testthat/`:
- Test files mirror R/ files: `test-<filename>.R`
- Use `test_that("description", { ... })` blocks
- Each test should be independent and hermetic

## Test Best Practices

### Hermetic Tests
- Each `test_that()` block should set up its own data inline
- Minimize top-level code outside `test_that()` blocks
- Tests should pass in any order and in isolation

### Temporary State
- Use `withr::local_*()` for temporary changes:
  - `withr::local_options()`
  - `withr::local_envvar()`
  - `withr::local_dir()`
- Use `withr::local_tempfile()` or `withr::local_tempdir()` for temporary files
- Never write directly to home or working directories

### Test Data
- Store static test data in `tests/testthat/fixtures/`
- Load with `readRDS(test_path("fixtures", "file.rds"))`
- Keep fixtures organized and documented

### Testing Reactive Code
- Test business logic outside of Shiny context when possible
- Use testServer() for testing Shiny modules
- Mock external dependencies when needed

## Assertions

Use `testthat` functions:
- `expect_true()`, `expect_false()`
- `expect_equal()`, `expect_identical()`
- `expect_error()` with `class = "error_class"` parameter
- `expect_warning()`, `expect_message()`
- `expect_silent()`

## Skipping Tests

For slow or network-dependent tests:
```r
test_that("slow test", {
  skip_on_cran()
  # test code
})
```

## Test Coverage

Aim for high code coverage:
- Run `covr::report()` to see coverage
- Test both happy path and error cases
- Test boundary conditions
- Test interaction between modules

## Command Line Options

Run specific test files:
```r
Rscript -e "devtools::test(filter = 'mod_name')"
```

Run tests with coverage:
```r
Rscript -e "covr::report()"
```
