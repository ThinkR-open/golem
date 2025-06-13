#' Generate a README.Rmd
#' @inheritParams usethis::use_readme_rmd
#' @inheritParams add_module
#' @inheritParams fill_desc
#' @param overwrite an optional \code{logical} flag; if \code{TRUE}, overwrite
#'   existing \code{README.Rmd}, else throws an error if \code{README.Rmd} exists
#'
#' @return pure side-effect function that generates template \code{README.Rmd}
#' @export
use_readme_rmd <- function(
	open = rlang::is_interactive(),
	pkg_name = golem::get_golem_name(),
	overwrite = FALSE,
	golem_wd = golem::get_golem_wd(),
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stopifnot(
		`Arg. 'overwrite' must be logical` = is.logical(
			overwrite
		)
	)

	# We move the working directory to perform this action,
	# in case we're launching the action from somewhere else
	old <- setwd(
		golem_wd
	)
	on.exit(
		setwd(
			old
		)
	)

	# Guess the readme path
	readme_path <- file.path(
		golem_wd,
		"README.Rmd"
	)

	# Removing the README if it already exists and overwrite is TRUE
	check_overwrite(
		overwrite,
		readme_path
	)

	usethis_use_readme_rmd(
		open = open
	)

	readme_tmpl <- generate_readme_tmpl(
		pkg_name = pkg_name
	)

	write(
		x = readme_tmpl,
		file = readme_path,
		append = FALSE,
		sep = "\n"
	)
	return(
		invisible(
			TRUE
		)
	)
}

check_overwrite <- function(
	overwrite,
	tmp_pth
) {
	# If the user wants to overwrite, we remove the file
	# Otherwise, error if the file already exists
	if (
		file.exists(
			tmp_pth
		)
	) {
		if (
			isTRUE(
				overwrite
			)
		) {
			unlink(
				tmp_pth,
				TRUE,
				TRUE
			)
		} else {
			stop(
				"README.Rmd already exists. Set `overwrite = TRUE` to overwrite."
			)
		}
	}
}

generate_readme_tmpl <- function(
	pkg_name
) {
	tmp_file <- readLines(
		golem_sys(
			"utils/empty_readme.Rmd"
		)
	)
	return(
		sprintf(
			tmp_file,
			pkg_name
		)
	)
}
