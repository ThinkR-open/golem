#' Add recommended elements
#'
#' @inheritParams add_module
#' @inheritParams usethis::use_spell_check
#' @param spellcheck Whether or not to use a spellcheck test.
#'
#' @rdname use_recommended
#'
#' @export
#'
#' @return Used for side-effects.
#'
#' @rdname use_recommended
#' @export
#' @importFrom utils capture.output
#' @importFrom attempt without_warning stop_if
use_recommended_tests <- function(
	golem_wd = get_golem_wd(),
	spellcheck = TRUE,
	vignettes = TRUE,
	lang = "en-US",
	error = FALSE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	old <- setwd(
		fs_path_abs(
			golem_wd
		)
	)

	on.exit(
		setwd(
			old
		)
	)

	if (
		!fs_dir_exists(
			fs_path(
				fs_path_abs(
					golem_wd
				),
				"tests"
			)
		)
	) {
		without_warning(
			usethis_use_testthat
		)()
	}
	if (
		!requireNamespace(
			"processx"
		)
	) {
		stop(
			"Please install the {processx} package to add the recommended tests."
		)
	}

	stop_if(
		fs_path(
			golem_wd,
			"tests",
			"testthat",
			"test-golem-recommended.R"
		),
		fs_file_exists,
		"test-golem-recommended.R already exists. \nPlease remove it first if you need to reinsert it."
	)

	fs_file_copy(
		golem_sys(
			"utils",
			"test-golem-recommended.R"
		),
		fs_path(
			golem_wd,
			"tests",
			"testthat"
		),
		overwrite = TRUE
	)

	if (spellcheck) {
		usethis_use_spell_check(
			vignettes = vignettes,
			lang = lang,
			error = error
		)
	}
	cli_alert_success(
		"Tests added."
	)
}
