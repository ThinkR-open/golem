#' Insert an hidden browser button
#'
#' See \url{https://rtask.thinkr.fr/a-little-trick-for-debugging-shiny/} for more context.
#'
#' @return Used for side effects.
#'     Prints the code to the console.
#' @export
#'

browser_button <- function() {
	cli_cat_rule(
		"To be copied in your UI"
	)
	cli_cat_line(
		crayon_darkgrey(
			'actionButton("browser", "browser"),'
		)
	)
	cli_cat_line(
		crayon_darkgrey(
			'tags$script("$(\'#browser\').hide();")'
		)
	)
	cli_cat_line()
	cli_cat_rule(
		"To be copied in your server"
	)
	cli_cat_line(
		crayon_darkgrey(
			"observeEvent(input$browser,{"
		)
	)
	cli_cat_line(
		crayon_darkgrey(
			"  browser()"
		)
	)
	cli_cat_line(
		crayon_darkgrey(
			"})"
		)
	)
	cli_cat_line()
	cli_cat_line(
		"By default, this button will be hidden."
	)
	cli_cat_line(
		"To show it, open your web browser JavaScript console"
	)
	cli_cat_line(
		"And run $('#browser').show();"
	)
}
