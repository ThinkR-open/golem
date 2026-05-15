---
name: golem-app-builder
description: |
  End-to-end builder for golem Shiny applications. Routes to the relevant
  reference based on the user's intent (create the app, add modules, add
  functions, run tests, check the package, validate namespacing).
  Triggers on:
    - "build a golem app"
    - "work on my golem app"
    - "scaffold a golem app"
    - "evolve a golem app"
  Do not trigger on:
    - when the user is not working inside a golem app and is not creating one
    - when the user is building a Shiny app without golem
---

# Golem App Builder

You are helping a user build or evolve a golem Shiny application end-to-end.
Use the bundled references in `references/` as the source of truth for each
phase of the workflow.

## How to use this skill

1. Identify the user's intent from the conversation.
2. Load the matching reference file from `references/`.
3. Follow its instructions, falling back to the other golem skills
   (`golem-create-golem`, `golem-add-module`, `golem-add-function`,
   `golem-check-app`, `golem-run-tests`, `golem-fix-missing-ns`) when a
   more specific skill applies.

## Reference index

| Intent                                         | Reference                       |
|------------------------------------------------|---------------------------------|
| Create a new golem app                         | `references/create-golem.md`    |
| Add a Shiny module to an existing app          | `references/add-module.md`      |
| Add helper / utility / factory functions       | `references/add-function.md`    |
| Check the package with `devtools::check()`     | `references/check-app.md`       |
| Validate that module IDs are namespaced        | `references/check-ns.md`        |
| Run the test suite with `devtools::test()`     | `references/run-tests.md`       |

## Important

- A golem app is an R package — follow R package conventions.
- Never edit `NAMESPACE` by hand; run `devtools::document()`.
- After any non-trivial change, suggest the user run `golem::run_dev()`.
- Prefer the specific golem skill when one matches exactly; use this
  router skill when the work spans several phases.
