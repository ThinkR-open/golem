#' maintenance_page
#'
#' A default html page for maintenance mode
#'
#' @importFrom shiny htmlTemplate
#'
#' @return an html_document
#' @details see the vignette \code{vignette("f_extending_golem", package = "golem")} for details.
#' @export
maintenance_page <- function() {
	shiny::htmlTemplate(
		filename = system.file(
			"app",
			"maintenance.html",
			package = "golem"
		)
	)
}
