---
name: golem-fix-missing-ns-colin
description: |
  Validate that all module input/output IDs are properly namespaced.
  Triggers on:
    - "check my modules for missing ns"
    - "find missing ns in modules"
    - "validate module namespaces"
  Do not trigger on:
    - when the user is not working inside a golem app
---

# Check for Missing `ns()` in Modules

Validate that all module input/output IDs are properly namespaced.

## Why Namespacing Matters

In Shiny modules, all input and output IDs must be namespaced using the `ns()` function. This prevents ID conflicts when the same module is used multiple times in an app.

## Correct vs Incorrect

### ✅ Correct

```r
mod_analytics_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("type_filter"),
      label = NULL,
      choices = c("All", "None")
    )
  )
}
```

### ❌ Incorrect

```r
mod_analytics_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      "type_filter",  # Missing ns()!
      label = NULL,
      choices = c("All", "None")
    )
  )
}
```

## What to Check

### In Module UI Functions
- All input IDs: `textInput()`, `selectInput()`, `actionButton()`, etc.
- All output IDs: `plotOutput()`, `tableOutput()`, `uiOutput()`, etc.
- All input control IDs used in `ns()` calls

### In Module Server Functions
- JavaScript handler IDs that reference the module namespace
- `observeEvent(input$...)` references
- `output$...` definitions
- `renderUI()` generated element IDs

### Places to Look
- Any file starting with `mod_` in the `R/` directory
- Both UI and server functions within modules

## How Claude Checks

1. **Locate all IDs** in module files (files starting with `mod_`)
   - Search for common patterns: `Input()`, `Output()`, input/output IDs

2. **Verify namespacing** by checking each ID is wrapped in `ns()`
   - Exception: Only the first `NS(id)` definition doesn't need wrapping

3. **Report findings**
   - If all IDs are properly namespaced: ✅ All good
   - If missing IDs found: ❌ List them and ask for permission to fix

4. **Fix if approved**
   - Wrap missing IDs in `ns()`
   - Preserve code structure and formatting

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `selectInput("myid", ...)` | `selectInput(ns("myid"), ...)` |
| `plotOutput("plot")` | `plotOutput(ns("plot"))` |
| `observeEvent(input$button)` | `observeEvent(input$submit, ...)` with ID properly namespaced |
| `uiOutput("dynamic")` | `uiOutput(ns("dynamic"))` |

## When to Run

- After creating or modifying module UI functions
- Before running `devtools::check()`
- When adding new inputs/outputs to modules
- Before deploying to production

## Example Workflow

```
User: Check my modules for missing ns()

Claude:
1. Scans all mod_*.R files
2. Identifies 3 missing ns() wrappings
3. Shows the issues with line numbers
4. Asks: "Should I fix these?"

User: Yes, fix them

Claude:
- Updates the files
- Runs the check again to verify
- Confirms: "All fixed! ✅"
```

## Notes

- This check is for UI and reactive server code, not data processing functions
- Only module files (`mod_*.R`) need this check
- Regular functions (`fct_*.R`, `utils_*.R`) don't need namespace wrapping
- Module server functions are called with the module ID, which handles the namespacing
