# All functions here check that {cli} is installed.
# This is done only when golem is not set to quiet mode.
check_cli_installed <- function(
	reason = "to have attractive command line interfaces with {golem}.\nYou can install all {golem} dev dependencies with `golem::install_dev_deps()`."
) {
	rlang::check_installed(
		"cli",
		version = "2.0.0",
		reason = reason
	)
}

cli_cat_line <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cat_line(
			...
		)
	})
}

cli_cat_rule <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cat_rule(
			...
		)
	})
}

cli_alert <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_alert(
			...
		)
	})
}

cli_alert_info <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_alert_info(
			...
		)
	})
}

cli_alert_success <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_alert_success(
			...
		)
	})
}

cli_alert_danger <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_alert_danger(
			...
		)
	})
}

cli_alert_warning <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_alert_warning(
			...
		)
	})
}

cli_progress_bar <- function(
	...
) {
	do_if_unquiet({
		check_cli_installed()

		cli::cli_progress_bar(
			...
		)
	})
}

cli_progress_update <- function(
	id = NULL,
	...
) {
	if (is.null(id)) {
		return(invisible(NULL))
	}

	do_if_unquiet({
		check_cli_installed()

		try(
			cli::cli_progress_update(
				id = id,
				...
			),
			silent = TRUE
		)
	})
}

cli_progress_done <- function(
	id = NULL,
	...
) {
	if (is.null(id)) {
		return(invisible(NULL))
	}

	do_if_unquiet({
		check_cli_installed()

		try(
			cli::cli_progress_done(
				id = id,
				...
			),
			silent = TRUE
		)
	})
}

cli_abort <- function(
	message
) {
	if (
		rlang::is_installed(
			"cli"
		)
	) {
		cli::cli_abort(
			message = message,
			call = NULL
		)
	} else {
		stop(
			message
		)
	}
}
