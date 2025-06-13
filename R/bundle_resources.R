#' Automatically serve golem external resources
#'
#' This function is a wrapper around `htmltools::htmlDependency` that
#' automatically bundles the CSS and JavaScript files in `inst/app/www`
#' and which are created by `golem::add_css_file()` , `golem::add_js_file()`
#' and `golem::add_js_handler()`.
#'
#' This function also preload [activate_js()] which allows to
#' use preconfigured JavaScript functions via [invoke_js()].
#'
#' @param path The path to the folder where the external files are located.
#' @param app_title The title of the app, to be used as an application title.
#' @param app_builder The name of the app builder to add as a meta tag.
#' Turn to NULL if you don't want this meta tag to be included.
#' @inheritParams htmltools::htmlDependency
#' @param with_sparkles C'est quand que tu vas mettre des paillettes dans ma vie Kevin?
#' @param activate_js Boolean to enable or disable the injection of JavaScript via activate_js().
#'
#' @importFrom htmltools htmlDependency
#' @export
#'
#' @return an htmlDependency
bundle_resources <- function(
	path,
	app_title,
	name = "golem_resources",
	version = "0.0.1",
	meta = NULL,
	head = NULL,
	attachment = NULL,
	package = NULL,
	all_files = TRUE,
	app_builder = "golem",
	with_sparkles = FALSE,
	activate_js = TRUE
) {
	res <- list()
	if (
		length(
			list.files(
				path
			)
		) >
			0
	) {
		res[[
			length(
				res
			) +
				1
		]] <- htmltools::htmlDependency(
			name,
			version,
			src = path,
			script = list.files(
				path,
				pattern = "\\.js$",
				recursive = TRUE
			),
			meta = c(
				"app-builder" = app_builder,
				meta
			),
			head = c(
				as.character(
					tags$title(
						app_title
					)
				),
				{
					if (activate_js) {
						as.character(
							golem::activate_js()
						)
					}
				},
				head
			),
			attachment = attachment,
			package = package,
			all_files = all_files
		)
		# For some reason `htmlDependency` doesn't bundle css,
		# So add them by hand
		css_list <- list.files(
			path,
			pattern = "\\.css$",
			recursive = TRUE
		)

		if (
			length(
				css_list
			) >
				0
		) {
			css_nms <- paste0(
				basename(
					path
				),
				"/",
				list.files(
					path,
					pattern = "\\.css$",
					recursive = TRUE
				)
			)

			for (i in css_nms) {
				res[[
					length(
						res
					) +
						1
				]] <- tags$link(
					href = i,
					rel = "stylesheet"
				)
			}
		}
	}

	if (with_sparkles) {
		res[[
			length(
				res
			) +
				1
		]] <- htmlDependency(
			"sparkles",
			version = utils::packageVersion(
				"golem"
			),
			src = system.file(
				"utils",
				package = "golem"
			),
			script = "sparkle.js"
		)
	}

	res
}
