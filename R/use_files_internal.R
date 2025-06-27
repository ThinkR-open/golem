#' @export
#' @rdname use_files
use_internal_js_file <- function(
	path,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	dir_create,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	perform_checks_and_copy_if_everything_is_ok(
		path_to_copy_from = path,
		directory_to_copy_to = fs_path_abs(
			dir
		),
		file_type = "js",
		file_created_fun = after_creation_message_js,
		golem_wd = golem_wd,
		name = name,
		open = open
	)
}

#' @export
#' @rdname use_files
use_internal_css_file <- function(
	path,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	dir_create,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	perform_checks_and_copy_if_everything_is_ok(
		path_to_copy_from = path,
		directory_to_copy_to = fs_path_abs(
			dir
		),
		file_type = "css",
		file_created_fun = after_creation_message_css,
		golem_wd = golem_wd,
		name = name,
		open = open
	)
}

#' @export
#' @rdname use_files
use_internal_html_template <- function(
	path,
	name = "template.html",
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	dir_create,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	perform_checks_and_copy_if_everything_is_ok(
		path_to_copy_from = path,
		directory_to_copy_to = fs_path_abs(dir),
		file_type = "html",
		file_created_fun = after_creation_message_html_template,
		golem_wd = golem_wd,
		name = name,
		open = open
	)
}

#' @export
#' @rdname use_files
use_internal_file <- function(
	path,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	dir_create,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	perform_checks_and_copy_if_everything_is_ok(
		path_to_copy_from = path,
		directory_to_copy_to = fs_path_abs(dir),
		file_type = NULL,
		file_created_fun = after_creation_message_html_template,
		golem_wd = golem_wd,
		name = name,
		open = open
	)
}
