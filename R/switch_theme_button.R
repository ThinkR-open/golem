#' @export
switch_theme_button <- function(inputId, label = NULL) {
  if (!rlang::is_installed("bslib")) {
    stop("You need to install bslib to use this function")
  }

  button <- bslib::input_switch(
    id = inputId,
    label = label,
    width = "fit-content"
  ) |>
    shiny::tagAppendAttributes(
      class = "golem-switch-themer"
    )

  css_file_path <- system.file(
    "utils",
    "golem_button_theme.css",
    package = "golem"
  )

  css_dependency <- htmltools::htmlDependency(
    name = "golem-switch-themer-css",
    version = "1.0.0",
    src = dirname(css_file_path),
    stylesheet = basename(css_file_path)
  )

  button_with_dependency <- htmltools::attachDependencies(button, css_dependency)

  button_with_dependency
}
