# Add Module

You are helping a user add a new module to an existing golem Shiny application.

## Creating a Module

Use `golem::add_module("name", with_test = TRUE)` to create a new module with proper structure.

## Module Structure

A golem module consists of:
- `mod_<name>_ui()` - User interface function
- `mod_<name>_server()` - Server logic function

## Important Rules

### UI Functions
- Always use `ns <- NS(id)` to namespace UI elements
- Check for missing `ns` prefixes when building the UI
- Never forget to namespace input/output IDs

### Server Functions
- Use `moduleServer()` - NEVER use the deprecated `callModule()`
- Use `reactiveValues()` for internal state, NOT `reactive()` or `reactiveVal()`
- Use `observeEvent()` - NEVER use `observe()`
- Always put reactive values inside a reactive consumer

Example pattern:
```r
mod_<name>_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    local_rv <- reactiveValues()
    
    observeEvent(
      input$btn,
      {
        local_rv$value <- compute_things(input$btn)
      }
    )
    
    output$plot <- renderPlot({
      local_rv$value
    })
  })
}
```

### Reactive Programming Rules
- NEVER pass `reactive()` objects between modules unless explicitly prompted
- Avoid `renderUI()` + `uiOutput()` - prefer `update*()` functions
- Watch for reactive cycles (A updates B updates A) - break them with explicit conditions
- Use a `reactiveValues()` object for sharing data between modules, but only include what's necessary

## Testing
- Create tests with `usethis::use_test("mod_<name>")`
- Each test should set up its own data inline
- Use `withr::local_*()` for temporary state changes

## Next Steps
After adding the module:
1. Edit the module files to add your UI and server logic
2. Run `devtools::document()` if you added roxygen comments
3. Add the module to your app UI in `app_ui.R`
4. Call it in `app_server()` with `mod_<name>_server("module_id")`
5. Run tests with `devtools::test()`
