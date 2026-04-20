#' Create a {pascal} output
#'
#' @param outputId The output slot that will be used to display the value.
#' @param ... Additional HTML attributes passed to the output element.
#'
#' @export
{output_constructor} <- function(outputId, ...) {
  shiny::tags$div(
    id = outputId,
    class = "golem-{file}-output",
    `data-output-type` = "{output_type}",
    ...
  )
}

#' Render a {pascal} output
#'
#' @param expr An expression that returns the value to display.
#' @param env The parent environment for the reactive expression.
#' @param quoted Is the expression quoted?
#' @param outputArgs A list of arguments to pass through to the output function.
#'
#' @export
{render_output} <- function(expr, env = parent.frame(), quoted = FALSE, outputArgs = list()) {
  func <- shiny::installExprFunction(
    expr,
    "func",
    env,
    quoted,
    label = "{render_output}"
  )

  shiny::createRenderFunction(
    func,
    transform = function(value, session, name, ...) {
      list(
        value = as.character(value)
      )
    },
    outputFunc = {output_constructor},
    outputArgs = outputArgs
  )
}
