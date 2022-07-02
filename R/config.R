# This file contains everything related to the
# manipulation of the golem-config file

# We first need something to guess where the file
# is. 99.99% of the time it will be
# ./inst/golem-config.yml but if for some reason
# you're somewhere else, functions still need to
# work

#' @importFrom attempt attempt is_try_error
#' @importFrom fs path path_abs
guess_where_config <- function(
	path = ".",
	file = "inst/golem-config.yml"
) {
	# We'll try to guess where the path
	# to the golem-config file is

	# This one should be correct in 99% of the case
	# => current directory /inst/golem-config.yml
	ret_path <- path(
		path,
		file
	)
	if (file_exists(ret_path)) {
		return(path_abs(ret_path))
	}

	# Maybe for some reason we are in inst/
	ret_path <- "golem-config.yml"
	if (file_exists(ret_path)) {
		return(path_abs(ret_path))
	}

	# Trying with pkg_path
	ret_path <- attempt({
		path(
			golem::pkg_path(),
			"inst/golem-config.yml"
		)
	})

	if (
		!is_try_error(ret_path) &
			file_exists(ret_path)
	) {
		return(
			path_abs(ret_path)
		)
	}
	return(NULL)
}

#' @importFrom fs file_copy path
get_current_config <- function(
	path = ".",
	set_options = TRUE
) {

	# We check wether we can guess where the config file is
	path_conf <- guess_where_config(path)

	# We default to inst/ if this doesn't exist
	if (is.null(path_conf)) {
		path_conf <- path(
			path,
			"inst/golem-config.yml"
		)
	}

	if (!file_exists(path_conf)) {
		if (interactive()) {
			ask <- yesno(
				sprintf(
					"The %s file doesn't exist.\nIt's possible that you might not be in a {golem} based project.\n Do you want to create the {golem} files?",
					basename(path_conf)
				)
			)
			# Return early if the user doesn't allow
			if (!ask) {
				return(NULL)
			}

			file_copy(
				path = golem_sys("shinyexample/inst/golem-config.yml"),
				new_path = path(
					path,
					"inst/golem-config.yml"
				)
			)
			file_copy(
				path = golem_sys("shinyexample/R/app_config.R"),
				new_path = file.path(
					path,
					"R/app_config.R"
				)
			)
			replace_word(
				path(
					path,
					"R/app_config.R"
				),
				"shinyexample",
				golem::pkg_name()
			)
			if (set_options) {
				set_golem_options()
			}
		} else {
			stop(
				sprintf(
					"The %s file doesn't exist.",
					basename(path_conf)
				)
			)
		}
	}

	return(
		invisible(path_conf)
	)
}

# This function changes the name of the
# package in app_config when you need to
# set the {golem} name
change_app_config_name <- function(
	name,
	path = get_golem_wd()
) {
	pth <- fs::path(path, "R", "app_config.R")
	app_config <- readLines(pth)

	where_system.file <- grep("system.file", app_config)

	app_config[
		where_system.file
	] <- sprintf(
		'  system.file(..., package = "%s")',
		name
	)
	write(app_config, pth)
}


# find and tag expressions in a yaml
# used internally in `amend_golem_config`
#' @importFrom utils modifyList
find_and_tag_exprs <- function(conf_path) {
	conf <- yaml::read_yaml(conf_path, eval.expr = FALSE)
	conf.eval <- yaml::read_yaml(conf_path, eval.expr = TRUE)

	expr_list <- lapply(names(conf), function(x) {
		conf[[x]][!conf[[x]] %in% conf.eval[[x]]]
	})
	names(expr_list) <- names(conf)
	expr_list <- Filter(function(x) length(x) > 0, expr_list)
	add_expr_tag <- function(tag) {
		attr(tag[[1]], "tag") <- "!expr"
		tag
	}
	tagged_exprs <- lapply(expr_list, add_expr_tag)
	modifyList(conf, tagged_exprs)
}

#' Amend golem config file
#'
#' @param key key of the value to add in `config`
#' @inheritParams config::get
#' @inheritParams add_module
#' @inheritParams set_golem_options
#'
#' @export
#' @importFrom yaml read_yaml write_yaml
#' @importFrom attempt stop_if
#'
#' @return Used for side effects.
amend_golem_config <- function(
	key,
	value,
	config = "default",
	pkg = get_golem_wd(),
	talkative = TRUE
) {
	conf_path <- get_current_config(pkg)
	stop_if(
		conf_path,
		is.null,
		"Unable to retrieve golem config file."
	)
	cat_if_talk <- function(..., fun = cat_green_tick) {
		if (talkative) {
			fun(...)
		}
	}

	cat_if_talk(
		sprintf(
			"Setting `%s` to %s",
			key,
			value
		)
	)

	if (key == "golem_wd") {
		cat_if_talk(
			"You can change golem working directory with set_golem_wd('path/to/wd')",
			fun = cat_line
		)
	}

	conf <- find_and_tag_exprs(conf_path)
	conf[[config]][[key]] <- value
	write_yaml(
		conf,
		conf_path
	)
	invisible(TRUE)
}
