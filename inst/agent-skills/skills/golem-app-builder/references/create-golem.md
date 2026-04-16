# Create Golem App

You are helping a user create a new golem Shiny application. Follow the guidelines in the CLAUDE.md file from the golem-claude repository.

## Key Steps

1. Use `golem::create_golem(name)` to create the application
2. The name should be the basename of the desired folder, or one provided by the user
3. Never create the folder yourself - golem will do it
4. After creation, guide the user to run `Rscript -e "golem::run_dev()"` from within the new app directory

## Important Rules

- A golem app IS an R package - follow all R package conventions
- Keep the `R/` folder flat - no subfolders
- Use `usethis::use_build_ignore()` for files that don't fit the package structure
- Never edit `NAMESPACE` by hand
- Use `devtools::document()` after any roxygen changes
- Development scripts go in `dev/` folder
- Data creation goes in `data-raw/` folder
- Follow the tidyverse style guide

## Module Naming Convention

- Modules: `R/mod_<name>.R`
- Module functions: `R/mod_<name>_fct_<fn>.R`
- Module utilities: `R/mod_<name>_utils_<fn>.R`
- Standalone functions: `R/fct_<name>.R`
- Utilities: `R/utils_<name>.R`

## Testing

Always create modules and functions with tests:
- `golem::add_module("name", with_test = TRUE)`
- `golem::add_fct("name", with_test = TRUE)`
- `golem::add_utils("name", with_test = TRUE)`

## Next Steps After Creation

After creating the app, remind the user to:
1. Navigate to the created folder
2. Run `Rscript -e "golem::run_dev()"` to launch the app
3. Use `devtools::test()` to run tests
4. Use `devtools::document()` when adding roxygen documentation
