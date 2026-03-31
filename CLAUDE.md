# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What is golem

golem is an R package providing an opinionated framework for building production-grade Shiny applications as R packages. It scaffolds projects, manages modules, handles configuration, and supports deployment (Docker, RStudio Connect, etc.).

## Common Commands

```r
# Run tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-utils.R")

# Full R CMD check (must pass with 0 errors, 0 warnings, 0 notes)
devtools::check()

# Document (regenerate NAMESPACE, Rd files)
devtools::document()

# Load package for interactive testing
devtools::load_all()

# Lint
air format .
```

## Code Style

- **Formatter:** `air format .`
- **Pre-commit:** uses `air` formatter (see `.pre-commit-config.yaml`)

## Architecture

### Project Template (`inst/shinyexample/`)

The scaffolding template copied by `create_golem()`. Contains the standard app structure: `R/app_ui.R`, `R/app_server.R`, `R/app_config.R`, `R/run_app.R`, `inst/golem-config.yml`, and dev scripts (`dev/01_start.R`, `dev/02_dev.R`, `dev/03_deploy.R`).

### Core Source Organization (`R/`)

Files are grouped by functionality:

- **Scaffolding:** `create_golem.R` — project creation
- **File generators:** `add_files.R` (JS/CSS/HTML), `add_r_files.R` (fct/utils/R6), `add_dockerfiles.R`, `add_dockerfiles_renv.R`
- **Module system:** `modules_fn.R` — `add_module()` creates `mod_<name>.R` with UI+server, optional `_fct`, `_utils`, `_class`, and test files
- **Configuration:** `config.R`, `golem-yaml-get.R`, `golem-yaml-set.R`, `golem-yaml-utils.R`, `set_golem_options.R`
- **Runtime:** `with_opt.R` (`with_golem_options()`), `make_dev.R` (dev/prod mode), `bundle_resources.R`, `js.R`
- **Templates:** `templates.R` — template functions for JS, CSS, SASS, HTML files
- **Bootstrap files:** `bootstrap_*.R` — lazy-load optional dependencies (cli, fs, usethis, roxygen2, etc.)
- **Messaging:** `cats.R`, `cli_msg.R` — console output helpers
- **Utilities:** `utils.R`, `pkg_tools.R`, `desc.R`

### Dev/Prod Mode

Controlled by `getOption("golem.app.prod")`. `app_dev()` / `app_prod()` check this. `make_dev(fun)` wraps any function to only execute in dev mode. Pre-made wrappers: `cat_dev()`, `print_dev()`, `message_dev()`, `warning_dev()`.

### Configuration System

YAML-based via `inst/golem-config.yml` using the `config` package. Supports `default`, `production`, `dev` profiles. Accessed via `get_golem_config()`. Environment variables: `GOLEM_CONFIG_ACTIVE`, `R_CONFIG_ACTIVE`.

### Bootstrap Pattern for Optional Dependencies

Functions from suggested packages (cli, fs, usethis, etc.) are wrapped in `bootstrap_*.R` files that check availability and provide fallbacks, avoiding hard imports.

## Testing

- **Framework:** testthat edition 3
- **Key test helpers** (in `tests/testthat/setup.R`):
  - `perform_inside_a_new_golem(fun)` — runs `fun` inside a fresh golem project in an isolated `callr` session
  - `run_quietly_in_a_dummy_golem(expr)` — creates a temporary golem project, runs `expr` inside it with `withr::with_dir`, cleans up after
  - `create_dummy_golem()` — creates a throwaway golem in tempdir
  - `expect_exists(path)` — asserts file exists
- Tests use `callr` for process isolation and `withr` for temporary state
- Snapshot tests live in `tests/testthat/_snaps/`

## Contributing Conventions

- PRs target the `master` branch, and should allow modification by maintainer
- PR messages must reference the issue and include NEWS.md category: `## New Functions`, `## New features`, `## Breaking changes`, `## Bug fix`, `## Internal changes`
