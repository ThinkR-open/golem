check_arg_with_agents_options <- function(with_agents_options) {
	if (is.null(with_agents_options)) {
		return(invisible(NULL))
	}
	if (!is.list(with_agents_options)) {
		cli_abort("`with_agents_options` must be `NULL` or a named list.")
	}
	if (!length(with_agents_options)) {
		return(invisible(NULL))
	}

	option_names <- names(with_agents_options)
	if (is.null(option_names) || any(!nzchar(option_names))) {
		cli_abort("`with_agents_options` must be a named list.")
	}
	if (anyDuplicated(option_names)) {
		cli_abort("Duplicated names in `with_agents_options`.")
	}

	use_skills_options <- setdiff(
		names(formals(use_skills)),
		c("golem_wd", "interactive")
	)
	names_with_agents_options <- names(with_agents_options)
	if (isFALSE(all(names_with_agents_options %in% use_skills_options))) {
		msg <- c(
			"Names in `with_agents_options` are wrong:",
			"names must match `use_skills()` argument names except",
			"`golem_wd` and `interactive`."
		)
		cli_abort(msg)
	}

	invisible(NULL)
}
create_golem_use_agents <- function(
	path_to_golem,
	with_agents_options,
	should_prompt
) {
	if (is.null(with_agents_options)) {
		options_set <- list()
	} else {
		options_set <- with_agents_options
	}
	options_set$golem_wd <- path_to_golem
	options_set$interactive <- should_prompt

	do.call(
		use_skills,
		options_set
	)
}
