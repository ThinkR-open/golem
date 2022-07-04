
#' @importFrom config get
get_golem_things <- function(
	value,
	config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
	use_parent = TRUE,
	path
) {
	conf_path <- get_current_config(path, set_options = TRUE)
	stop_if(
		conf_path,
		is.null,
		"Unable to retrieve golem config file."
	)
	config::get(
		value = value,
		config = config,
		file = conf_path,
		use_parent = TRUE
	)
}


#' @export
#' @rdname golem_opts
get_golem_wd <- function(
	use_parent = TRUE,
	path = golem::pkg_path()
) {
	get_golem_things(
		value = "golem_wd",
		config = "dev",
		use_parent = use_parent,
		path = path
	)
}

#' @export
#' @rdname golem_opts
get_golem_name <- function(
	config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
	use_parent = TRUE,
	path = golem::pkg_path()
) {
	nm <- get_golem_things(
		value = "golem_name",
		config = config,
		use_parent = use_parent,
		path = path
	)
	if (is.null(nm)) {
		nm <- golem::pkg_name()
	}
	nm
}

#' @export
#' @rdname golem_opts
get_golem_version <- function(
	config = Sys.getenv("R_CONFIG_ACTIVE", "default"),
	use_parent = TRUE,
	path = golem::pkg_path()
) {
	get_golem_things(
		value = "golem_version",
		config = config,
		use_parent = use_parent,
		path = path
	)
}
