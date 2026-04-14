---
name: golem-fix-missing-ns
description: |
  Finds missing ns() local scope calls inside Shiny modules.
  Triggers on:
    - "find missing ns"
    - "find missing ns()"
  Do not trigger on:
    - if outside an R Shiny app
    - if outside an R Shiny app which is not golem based
---

## Context

Shiny applications use IDs to identify inputs and outputs. These IDs must be
unique within an application, as accidentally using the same input/output ID
more than once will result in unexpected behavior. The traditional solution for
preventing name collisions is namespaces; a namespace is to an ID as a directory
is to a file. The `NS()` function turns a bare ID into a namespaced one.

**However**:

In module files, living under R/ and which typically start with
`mod_MODULE_NAME.R`, the code part `ns <- NS(id)` (often at the very top of
the module) defines a local function for Shiny module namespacing which makes
this easier to re-use in subsequent code parts of the module.

Thus, it is common practice to refer to `ns("some_id_as_string")` to refer to
UI/server ID pairs.

## Main task

Find missing or bad `ns()` calls inside modules by screening all `R/mod_XXX.R`
files, and possibly other files that are named differently but work as a module.

1. Run the bundled script from the project root:

   ```sh
   Rscript .agents/skills/golem-fix-missing-ns/scripts/find_missing_ns.R --format tsv
   ```

   For Claude Code installations, use:

   ```sh
   Rscript .claude/skills/golem-fix-missing-ns/scripts/find_missing_ns.R --format tsv
   ```

2. If the golem app uses module files that are not named `R/mod_*.R`, rerun
   with `--all-files`.
3. If the app uses custom input helper functions, rerun with `--functions`.
   Example: `--functions '^sk_.*_input$'`.
4. Use the reported file, line, column, function, argument, and suggested
   `ns()` wrapper to inspect the code before editing.

## Usage

Use this skill when creating, reviewing, or modifying a golem-based Shiny
application, and it is clear that the user wants to find, review, or fix
missing `ns()` calls in module UI code.
