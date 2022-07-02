#' `{golem}` options
#'
#' Set and get a series of options to be used with `{golem}`.
#' These options are found inside the `golem-config.yml` file, found in most cases
#' inside the `inst` folder.
#'
#' @section Set Functions:
#' + `set_golem_options()` sets all the options, with the defaults from the functions below.
#' + `set_golem_wd()` defaults to `here::here()`, which is the package root when starting a golem.
#' + `set_golem_name()` defaults `golem::pkg_name()`
#' + `set_golem_version()` defaults `golem::pkg_version()`
#'
#' @section Get Functions:
#' Reads the information from `golem-config.yml`
#' + `get_golem_wd()`
#' + `get_golem_name()`
#' + `get_golem_version()`
#'
#' @param golem_name Name of the current golem.
#' @param golem_version Version of the current golem.
#' @param golem_wd Working directory of the current golem package.
#' @param app_prod Is the `{golem}` in prod mode?
#' @param path The path to set the golem working directory.
#'     Note that it will be passed to `normalizePath`.
#' @param talkative Should the messages be printed to the console?
#' @param name The name of the app
#' @param version The version of the app
#' @inheritParams config::get
#'
#' @rdname golem_opts
#'
#' @export
#' @importFrom attempt stop_if_not
#' @importFrom usethis proj_set
#'
#' @return Used for side-effects for the setters, and values from the
#'     config in the getters.
set_golem_options <- function(
	golem_name = golem::pkg_name(),
	golem_version = golem::pkg_version(),
	golem_wd = golem::pkg_path(),
	app_prod = FALSE,
	talkative = TRUE,
	config_file = path(golem_wd, "inst/golem-config.yml")
) {

	# TODO here we'll run the
	# golem_install_dev_pkg() function

	if (talkative) {
		cli::cat_rule(
			"Setting {golem} options in `golem-config.yml`"
		)
	}

	# Let's start with wd
	# Basically here the idea is to be able
	# to keep the wd as an expr if it is the
	# same as golem::pkg_path(), otherwise
	# we use the explicit path

	set_golem_wd(
		path = path,
		talkative = talkative
	)

	# Setting name of the golem
	set_golem_name(
		name = golem_name,
		talkative = talkative
	)

	# Setting golem_version
	set_golem_version(
		version = golem_version,
		talkative = talkative
	)

	# Setting app_prod
	set_golem_things(
		"app_prod",
		app_prod,
		path = golem_wd,
		talkative = talkative
	)

	# This part is for {usethis} and {here}
	if (talkative) {
		cli::cat_rule(
			"Setting {usethis} project as `golem_wd`"
		)
	}

	proj_set(golem_wd)
}

set_golem_things <- function(
	key,
	value,
	path,
	talkative = TRUE,
	config = "default"
) {
	amend_golem_config(
		key = key,
		value = value,
		config = config,
		pkg = path,
		talkative = talkative
	)

	invisible(path)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_wd <- function(
	path = golem::pkg_path(),
	talkative = TRUE
) {
	if (
		path == "golem::pkg_path()" |
			path == golem::pkg_path()
	) {
		golem_yaml_path <- "golem::pkg_path()"
		attr(golem_yaml_path, "tag") <- "!expr"
	} else {
		golem_yaml_path <- path_abs(path)
	}

	set_golem_things(
		"golem_wd",
		golem_yaml_path,
		path,
		talkative = talkative,
		config = "dev"
	)

	invisible(path)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_name <- function(
	name = golem::pkg_name(),
	path = golem::pkg_path(),
	talkative = TRUE
) {
	path <- path_abs(path)
	# Changing in YAML
	set_golem_things(
		"golem_name",
		name,
		path,
		talkative = talkative
	)
	# Changing in app-config.R
	change_app_config_name(
		name = name,
		path = path
	)

	# Changing in DESCRIPTION
	desc <- desc::description$new(
		file = fs::path(
			path,
			"DESCRIPTION"
		)
	)
	desc$set(
		Package = name
	)
	desc$write(
		file = "DESCRIPTION"
	)

	invisible(name)
}

#' @export
#' @rdname golem_opts
#' @importFrom fs path_abs
set_golem_version <- function(
	version = golem::pkg_version(),
	path = golem::pkg_path(),
	talkative = TRUE
) {
	path <- path_abs(path)
	set_golem_things(
		"golem_version",
		as.character(version),
		path,
		talkative = talkative
	)
	desc <- desc::description$new(file = fs::path(path, "DESCRIPTION"))
	desc$set_version(
		version = version
	)
	desc$write(
		file = "DESCRIPTION"
	)

	invisible(version)
}

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
