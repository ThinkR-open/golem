This lookup table lists golem functions, parameters, and features mentioned in
`NEWS.md` as deprecated, removed, or renamed;

Legend:
- "Dpr.since:" means deprecated since the first golem version where the change appears.
- "depr" is short for deprecated as well.

| Function/feature name        | Dpr.since| Notes                                                         |
| ---                          | ---       | ---                                                          |
| `get_sysreqs()`              | 1.0.0     | Removed; use `dockerfiler::get_sysreqs()` instead.          |
| `use_recommended_deps()`     | 1.0.0     | Removed (was soft depr since 0.3.2); no replacement.         |
| `add_rstudioconnect_file()`  | 1.0.0     | Removed; use `add_positconnect_file()` instead.             |
| `browser_button()`           | 1.0.0     | Soft depr (#1155).                                          |
| `add_dockerfile()`           | 1.0.0     | Soft depr; use `add_dockerfile_with_renv()`                  |
| `add_dockerfile_shinyproxy()`| 1.0.0     | Soft depr; use `add_dockerfile_with_renv_shinyproxy()`       |
| `add_dockerfile_heroku()`    | 1.0.0     | Soft depr; use `add_dockerfile_with_renv_heroku()`           |
| `expect_html_equal(html = )` | 0.3.2     | Hard depr; `html` parameter is no longer in use              |
| `add_ui_server_files()`      | 0.3.1     | Soft depr; use only if `ui.R` and `server.R` files are needed|
| `get_dependencies`           | 0.2.1     | Removed; use `desc::desc_get_deps()` instead.                |
| `add_rconnect_file()`        | 0.0.1.60+ | Renamed to `add_rstudioconnect_file()`                       |
| `create_shiny_template()`    | 0.0.1.60+ | Renamed to `create_golem()`                                  |
| `js()`                       | 0.0.1.60+ | Renamed to `activate_js()`                                   |
| `use_recommended_dep()`      | 0.0.1.60+ | Renamed `use_recommended_deps()`, later soft depr. in 0.3.2. |
| `use_utils_prod`             | 0.0.1.50  | Removed; the utility is included in golem.                   |
