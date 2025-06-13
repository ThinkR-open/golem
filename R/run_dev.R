#' Run the `dev/run_dev.R` file
#'
#' The default `file="dev/run_dev.R"` launches your `{golem}` app with a bunch
#' of useful options. The file content can be customized and `file`-name and
#' path changed as long as the argument combination of `file` and `pkg` are
#' supplied correctly: the `file`-path is a relative path to a `{golem}`-package
#' root `pkg`. An error is thrown if `pkg/file` cannot be found.
#'
#' The function `run_dev()` is typically used to launch a shiny app by sourcing
#' the content of an appropriate `run_dev`-file. Carefully read the content of
#' `dev/run_dev.R` when creating your custom `run_dev`-file. It has already
#' many useful settings including a switch between production/development,
#' reloading the package in a clean `R` environment before running the app etc.
#'
#' @param file String with (relative) file path to a `run_dev.R`-file
#' @param install_required_packages Boolean; if `TRUE` install the packages
#'     used in `run_dev.R`-file
#' @param save_all Boolean; if `TRUE` saves all open files before sourcing
#'     `file`
#' @inheritParams add_module
#'
#' @export
#'
#' @return pure side-effect function; returns invisibly
run_dev <- function(
	file = "dev/run_dev.R",
	golem_wd = get_golem_wd(),
	save_all = TRUE,
	install_required_packages = TRUE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (save_all) {
		if (
			rlang::is_installed(
				"rstudioapi"
			) &&
				rstudioapi::isAvailable() &&
				rstudioapi::hasFun(
					"documentSaveAll"
				)
		) {
			rstudioapi::documentSaveAll()
		}
	}

	# We'll look for the run_dev script in the current dir
	try_dev <- file.path(
		golem_wd,
		file
	)

	# Stop if it doesn't exists
	if (
		file.exists(
			try_dev
		)
	) {
		run_dev_lines <- readLines(
			try_dev
		)
	} else {
		stop(
			"Unable to locate the run_dev-file passed via the 'file' argument."
		)
	}

	if (install_required_packages) {
		install_dev_deps(
			"attachment",
			force_install = install_required_packages
		)
		to_install <- attachment::att_from_rscript(
			path = try_dev
		)
		install_dev_deps(
			dev_deps = to_install,
			force_install = install_required_packages
		)
	}

	eval(
		parse(
			text = run_dev_lines
		)
	)
}
