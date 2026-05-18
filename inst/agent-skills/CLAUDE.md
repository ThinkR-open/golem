# Golem Shiny App Development Rules

This file provides guidance to claude when working with golem based Shiny Apps.

Use the project-local golem skills when changing app structure, modules,
resources, development scripts, deployment files, or tests.

## Key commands

```r
# Launch the app
Rscript -e "golem::run_dev()"

# Run tests
Rscript -e "devtools::test()"

# Check package
Rscript -e "devtools::check()"

# Regenerate documentation
Rscript -e "devtools::document()"

# Format code
air format .
```

## Communication

- When you finish a change, invite the user to launch the app with
  `golem::run_dev()`.
- Do not suggest `source("dev/run_dev.R")` or `pkgload::load_all(); run_app()`.

## Project structure

- A golem app is an R package. Follow normal package conventions:
  `DESCRIPTION`, `NAMESPACE`, `R/`, `tests/`, `inst/`, and package metadata.
- Keep `R/` flat. Do not create subfolders under `R/`.
- Never edit `NAMESPACE` by hand. Use `devtools::document()` or `roxygen2::roxygenize()`.
- Development scripts belong in `dev/`, never in `R/`.
- Data creation scripts belong in `data-raw/`
- Files outside package structure must be added to `.Rbuildignore`.
- Common extra folders include `renv`, `tools`, `doc`, `meta`, and `rsconnect`.

## File naming

- Modules: `R/mod_<name>.R`
- Module-specific functions: `R/mod_<name>_fct_<fn>.R`
- Module-specific utilities: `R/mod_<name>_utils_<fn>.R`
- Standalone functions: `R/fct_<name>.R`
- Utilities: `R/utils_<name>.R`
- Test file names mirror `R/` file names: `tests/testthat/test-*.R` where `*` is the corresponding file name under `R/`
- Static assets live in `inst/app/www/`

## Creating and changing files

- Create new apps with `golem::create_golem()`. Never create the initial app
  skeleton by hand.
- Use golem helpers instead of hand-creating standard files:
  `golem::add_module()`, `golem::add_fct()`, and `golem::add_utils()`.
- When available, create tests together with new modules and functions.
- Favor changing existing canonical files over creating alternate parallel
  structures.

## Development workflow

1. Edit `R/` and related package files.
2. Run `devtools::document()` if roxygen or imports changed.
3. Run `golem::run_dev()` to test interactively.
4. Run `devtools::test()`.
5. Run `devtools::check()` before release or major handoff.

## Modules

- Use `moduleServer()`, NEVER `callModule()` (deprecated).
- Always namespace UI ids with `ns <- NS(id)`.
- When changing a module UI, check for missing `ns()`.
- Do not pass reactive objects between modules unless the architecture clearly
  requires shared state.

## Reactive programming

- ALWAYS use `observeEvent()`. NEVER use `observe()`.
- ALWAYS use `reactiveValues()`. NEVER use `reactive()` or `reactiveVal()`.
- Read reactive state only inside reactive consumers.
- Avoid `renderUI()` and `uiOutput()` unless there is no simpler option.
- Prefer `update*()` functions and client-side show/hide where possible.
- Prefer `update*()` functions such as `updateSelectInput()`.
- Prefer JS-side show/hide over server-side UI regeneration.
- Watch for reactive cycles (A updates B updates A) and break them with explicit guards.
- If modules must share state, either use a global environment if the values can be shared across all shiny sessions, or a shared `reactiveValues()` object between modules. Use `reactiveValues()` parsimoniously and narrow down to only what needs to be shared across modules. Name `reactiveValues` meaningfully (bad: `r` or `rv`; good: `global_storage` or similar).

Example pattern to aim for:

Correct:

```r
local_rv <- reactiveValues(
  a = NULL
)

observeEvent(
  input$a,
  {
    local_rv$a <- input$a
  }
)
```

Bad:

```r
local_rv <- reactiveValues(
  a = NULL
)

local_rv$a <- input$a
```

## Code quality

- Follow the tidyverse style guide.
- Use `air format .` if available.
- Use `TRUE` and `FALSE`, never `T` and `F`.
- Use `<-` for assignment.
- No non-ASCII characters in `R/` files — use unicode escapes (`\uXXXX`) if the app is to be deployed on CRAN. Otherwise, create a file in `tools/`, that will contain `check.env`, with inside `_R_CHECK_ASCII_CODE_=FALSE`.
- Avoid global side effects such as `options()`, `setwd()`, or `Sys.setenv()`;
  if unavoidable, restore state with `on.exit(..., add = TRUE)` or `{withr}`.
- Do not use `library()`, `require()`, or `source()` inside package code.
- Avoid `:::` unless there is no viable public alternative.

## Dependencies

- Add dependencies with `usethis::use_package("pkg")`.
- Always use `@importFrom` on top of each function. Whenever you can, check if new `@importFrom` are required.
- Prefer specific packages over umbrella dependencies such as `{tidyverse}`.
- Use `Imports` rather than `Depends`, except for R version requirements.
- For optional packages, guard usage with `requireNamespace("pkg",
  quietly = TRUE)`, `rlang::check_installed("pkg")` or an equivalent check.
- Use minimum versions with `>=`, not exact pins.

## Documentation

- Exported functions must be documented with roxygen2.
- Enable markdown in roxygen where appropriate.
- Run `devtools::document()` after roxygen changes.
- Do not edit `.Rd` files by hand.
- Use `@noRd` for internal functions that should not generate manual pages.
- Prefer `@inheritParams` when it avoids duplicated parameter documentation.

## Configuration

- Environment configuration belongs in `golem-config.yml` and should be read
  with `get_golem_config()`.
- Runtime configuration belongs in `run_app()` parameters and should be read
  with `golem::get_golem_options()`.
- Never store secrets in tracked config files.

## Testing

- Use `usethis::use_test()` for new test files.
- Keep tests hermetic and self-contained.
- Minimize top-level test code outside `test_that()`.
- Use `{withr}` helpers for temporary state.
- Write temporary files only to temporary paths.
- Store static fixtures under `tests/testthat/fixtures/`.
- Prefer asserting on error classes instead of brittle message text.
- Use `skip_on_cran()` or similar guards for slow, external, or networked tests.
- Test business logic outside reactive contexts whenever possible.

## Deployment

- Prefer golem deployment helpers such as `golem::add_dockerfile()` where they
  fit the target platform.
- Do not hardcode environment-specific values.
- Ensure the package passes checks before deployment.
