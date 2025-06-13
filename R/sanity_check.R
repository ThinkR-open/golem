#' Sanity check for R files in the project
#'
#' This function is used check for any `browser()`` or commented
#' #TODO / #TOFIX / #BUG in the code
#'
#' @inheritParams add_module
#'
#' @rdname sanity_check
#' @export
#'
#'
#' @return A DataFrame if any of the words has been found.
sanity_check <- function(
	golem_wd = get_golem_wd(),
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	all_R_files <- list.files(
		path = golem_wd,
		pattern = "\\.R$",
		recursive = TRUE,
		full.names = TRUE
	)

	to_find <- c(
		"browser()",
		"#TODO",
		"#TOFIX",
		"#BUG",
		"# TODO",
		"# TOFIX",
		"# BUG"
	)

	source_markers <- data.frame()

	for (file_name in all_R_files) {
		file <- readLines(
			file_name,
			warn = FALSE
		)

		for (word in to_find) {
			line_number <- grep(
				word,
				file,
				fixed = TRUE
			)
			if (
				length(
					line_number
				) >
					0
			) {
				df <- data.frame(
					type = "warning",
					file = file_name,
					line = line_number,
					message = paste(
						"Found",
						word,
						sep = " "
					),
					column = 1
				)
				source_markers <- rbind.data.frame(
					source_markers,
					df
				)
			}
		}
	}
	if (
		length(
			source_markers
		) >
			0
	) {
		if (
			rlang::is_installed(
				"rstudioapi"
			) &&
				rstudioapi::isAvailable() &&
				rstudioapi::hasFun(
					"sourceMarkers"
				)
		) {
			rstudioapi::sourceMarkers(
				"sanity_check",
				markers = source_markers
			)
		}
		return(
			source_markers
		)
	} else {
		cat_green_tick(
			"Sanity check passed successfully."
		)
	}
}
