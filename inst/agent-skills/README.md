# golem-agent-skills

Shared `{golem}` skills packaged for Claude Code and OpenAI agents.

Canonical skill content lives in [`skills/`](./skills).

Made by [ThinkR](https://thinkr.fr/) for professional Shiny development.

## Overview

This repository provides:
- Claude Code and AGENTS plugin packaging around shared golem skills
- Best practice guidelines for Shiny app development
- A routed golem app builder skill for end-to-end app work
- Complete documentation for installation and development workflows

## What This Plugin Provides

A set of skills and guidelines for creating production-ready Shiny applications
following R package best practices and golem conventions.

### Skills

- **Golem App Builder** - Build and evolve golem applications using routed references
- **Golem Upgrade** - Upgrade golem apps across package and structure changes
- **Golem Fix Missing ns** - Check modules for missing `ns()`

## Key Features

- Enforces R package best practices
- Golem naming conventions and patterns
- Reactive programming guidelines
- Module and function templates
- Test-driven development support
- Complete documentation and examples

## Development Workflow

```text
Create App -> Add Modules -> Add Functions -> Test -> Check -> Deploy
```

## Key Commands

Once you have a golem app:

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

## File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Modules | `R/mod_<name>.R` | `R/mod_gpx_reader.R` |
| Module functions | `R/mod_<name>_fct_<fn>.R` | `R/mod_gpx_reader_fct_parse.R` |
| Module utilities | `R/mod_<name>_utils_<fn>.R` | `R/mod_gpx_reader_utils_validate.R` |
| Factory functions | `R/fct_<name>.R` | `R/fct_similarity_calc.R` |
| Utilities | `R/utils_<name>.R` | `R/utils_formats.R` |
| Tests | Mirror R/ | `tests/testthat/test-mod_gpx_reader.R` |

## Requirements

- R 4.0+
- `{golem}` package
- `{devtools}` package
- `{shiny}` package

## Claude Code installation

1. Add the marketplace from GitHub:
    ```text
    /plugin marketplace add ilyaZar/golem-agent-skills
    ```

2. Confirm the marketplace is available:
    ```text
    /plugin marketplace list
    ```

3. Install the plugin:
    ```text
    /plugin install golem-skills@thinkr
    ```

4. Reload plugins if prompted:
    ```text
    /reload-plugins
    ```

5. After installation, the following plugin skills should be available:
    ```text
    /golem-skills:golem-app-builder
    /golem-skills:golem-upgrade
    /golem-skills:golem-fix-missing-ns
    ```

## Remove the plugin

```text
/plugin uninstall golem-skills
/plugin marketplace remove thinkr
/reload-plugins
```

## `{golem}` package helper

The `golem::use_agent_skills()` (starting with version `0.6.0`) helper can also
install the same skill payloads into a `{golem}` project. It reads from the
canonical upstream `skills/` tree and copies into provider-specific target
directories in the consuming Shiny App project:

- Claude target: `.claude/skills/`
- AGENTS target: `.agents/skills/`

This keeps the upstream repository canonical while preserving the expected
project layout for each tool.
