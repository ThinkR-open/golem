#' Create a {pascal} input
#'
#' @param inputId The input slot that will be used to access the value.
#' @param label Display label for the input.
#' @param value Initial value.
#' @param ... Additional HTML attributes passed to the input element.
#'
#' @export
{
	input_constructor
} <- function(inputId, label, value = "", ...) {
	shiny::tags$div(
		class = "golem-{file}-input",
		shiny::tags$label(
			`for` = inputId,
			label
		),
		shiny::tags$input(
			id = inputId,
			type = "text",
			value = value,
			`data-input-type` = "{input_type}",
			class = "form-control",
			...
		)
	)
}

#' Update a {pascal} input
#'
#' @param session A Shiny session object.
#' @param inputId The id of the input object.
#' @param label New label value.
#' @param value New input value.
#'
#' @export
{
	update_input
} <- function(session, inputId, label = NULL, value = NULL) {
	message <- list()
	if (!is.null(label)) {
		message$label <- label
	}
	if (!is.null(value)) {
		message$value <- value
	}
	session$sendInputMessage(inputId, message)
}
