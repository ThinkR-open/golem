#' Enable documentation generation using roxygen2
#'
#' @param path to to Rproj file
#' @noRd
#'
enable_roxygenize <- function(
	path = list.files(
		path = ".",
		pattern = "Rproj$",
		full.names = TRUE
	)[1]
) {
	cli_alert_info(
		sprintf(
			"Reading %s content.",
			basename(
				path
			)
		)
	)
	source <- yaml::read_yaml(
		file = path
	)
	cli_alert_info("Enable roxygen2.")
	source[["PackageRoxygenize"]] <- "rd,collate,namespace"
	yaml::write_yaml(
		x = source,
		file = path
	)

	cli_alert_success(
		"Done."
	)
}
