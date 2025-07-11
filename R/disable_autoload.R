#' Disabling Shiny Autoload of R Scripts
#'
#' @inheritParams add_module
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   disable_autoload()
#' }
#' @return The path to the file, invisibly.
disable_autoload <- function(
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
	fls <- fs_path(
		golem_wd,
		"R",
		"_disable_autoload.R"
	)
	if (
		fs_file_exists(
			fls
		)
	) {
		cat_red_bullet(
			"_disable_autoload.R already exists, skipping its creation."
		)
	} else {
		cli_cat_rule(
			"Creating _disable_autoload.R"
		)
		write(
			"# Disabling shiny autoload\n\n# See ?shiny::loadSupport for more information",
			fls
		)
		cat_green_tick(
			"Created"
		)
	}
	return(
		invisible(
			fls
		)
	)
}
