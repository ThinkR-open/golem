#' Use Files
#'
#' These functions download files from external sources and put them inside the `inst/app/www` directory.
#' The `use_internal_` functions will copy internal files, while `use_external_` will try to download them
#' from a remote location.
#'
#' @inheritParams add_module
#' @param url String representation of URL for the file to be downloaded
#' @param path String representation of the local path for the file to be implemented (use_file only)
#' @param dir Path to the dir where the file while be created.
#' @param extract Whether to extract a downloaded HTML zip bundle. Use `"ask"` to prompt.
#'   Only used by `use_bundled_html()` and by `use_external_html_template()`
#'   when `url` points to a `.zip` archive.
#' @param delete_zip Whether to delete the raw HTML zip after extraction. Use `"ask"` to prompt.
#'   Only used by `use_bundled_html()` and by `use_external_html_template()`
#'   when `url` points to a `.zip` archive.
#' @param replace Boolean. If `TRUE`, an existing file at the target location is
#'   overwritten. Defaults to `FALSE`, in which case the function aborts if the
#'   target file already exists.
#'
#' @note See `?htmltools::htmlTemplate` and `https://shiny.rstudio.com/articles/templates.html`
#'     for more information about `htmlTemplate`.
#'
#' @export
#' @rdname use_files
#'
#' @return The path to the file, invisibly.
use_external_js_file <- function(
	url,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	replace = FALSE,
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

	perform_checks_and_download_if_everything_is_ok(
		url_to_download_from = url,
		directory_to_download_to = fs_path_abs(dir),
		file_type = "js",
		file_created_fun = after_creation_message_js,
		golem_wd = golem_wd,
		name = name,
		open = open,
		replace = replace
	)
}

#' @export
#' @rdname use_files
use_external_css_file <- function(
	url,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	replace = FALSE,
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

	perform_checks_and_download_if_everything_is_ok(
		url_to_download_from = url,
		directory_to_download_to = fs_path_abs(dir),
		file_type = "css",
		file_created_fun = after_creation_message_css,
		golem_wd = golem_wd,
		name = name,
		open = open,
		replace = replace
	)
}

#' @export
#' @rdname use_files
use_external_html_template <- function(
	url,
	name = "template.html",
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	replace = FALSE,
	dir_create,
	extract = c("ask", "yes", "no"),
	delete_zip = c("ask", "yes", "no")
) {
	if (!missing(dir_create)) {
		cli_abort_dir_create()
	}

	html_bundle <- check_if_html_bundle(url)

	if (html_bundle) {
		bundle_args <- list(
			url = url,
			golem_wd = golem_wd,
			dir = dir,
			open = open,
			replace = replace,
			extract = extract,
			delete_zip = delete_zip
		)
		if (!missing(name)) {
			bundle_args$name <- name
		}
		return(do.call(use_bundled_html, bundle_args))
	}

	perform_checks_and_download_if_everything_is_ok(
		url_to_download_from = url,
		directory_to_download_to = fs_path_abs(dir),
		file_type = "html",
		file_created_fun = after_creation_message_html_template,
		golem_wd = golem_wd,
		name = name,
		open = open,
		replace = replace
	)
}

check_if_html_bundle <- function(url) {
	file_ext(sub("\\?.*$", "", url)) == "zip"
}

#' @export
#' @rdname use_files
use_external_file <- function(
	url,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	replace = FALSE,
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

	perform_checks_and_download_if_everything_is_ok(
		url_to_download_from = url,
		directory_to_download_to = fs_path_abs(dir),
		file_type = NULL,
		file_created_fun = NULL,
		golem_wd = golem_wd,
		name = name,
		open = open,
		replace = replace
	)
}

#' @export
#' @rdname use_files
use_bundled_html <- function(
	url,
	name = NULL,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = FALSE,
	replace = FALSE,
	extract = c("ask", "yes", "no"),
	delete_zip = c("ask", "yes", "no")
) {
	extract <- match.arg(extract)
	delete_zip <- match.arg(delete_zip)
	old <- setwd(fs_path_abs(golem_wd))
	on.exit(setwd(old))
	dir <- fs_path_abs(dir)

	if (is.null(name)) {
		name <- "template"
	}
	name_zip <- build_name(name, url, with_ext = TRUE)
	name_bundle <- file_path_sans_ext(name_zip)

	if (file_ext(name_zip) == "zip") {
		where_zip <- fs_path(dir, name_zip)
	} else {
		where_zip <- fs_path(
			dir,
			sprintf("%s_bundle.zip", name_bundle)
		)
	}
	check_file_exists(where_zip, replace = replace)
	check_directory_exists(dir)

	where_bundle <- fs_path(dir, name_bundle)
	if (
		!isTRUE(replace) &&
			(fs_dir_exists(where_bundle) || fs_file_exists(where_bundle))
	) {
		cli_abort(
			sprintf(
				"%s already exists.\n\nYou can delete it with:\nunlink('%s', recursive = TRUE).\n\nAlternatively, call this function again with `replace = TRUE`.",
				where_bundle,
				where_bundle
			)
		)
	}
	if (isTRUE(replace)) {
		if (fs_dir_exists(where_bundle)) {
			fs_dir_delete(where_bundle)
		} else if (fs_file_exists(where_bundle)) {
			fs_file_delete(where_bundle)
		}
	}

	progress_id <- cli_progress_bar(
		name = "Using bundled HTML",
		total = 3,
		type = "tasks"
	)
	on.exit(cli_progress_done(id = progress_id), add = TRUE)
	download_external(url, where_zip)

	cli_progress_update(id = progress_id)
	if (identical(extract, "ask")) {
		extract <- cat_yes_no_or_cancel(
			sprintf(
				"Extract %s?",
				fs_path_file(where_zip)
			)
		)
	}
	if (identical(extract, "cancel")) {
		fs_file_delete(where_zip)
		cli_alert_warning("Abort html template download.")
		return(invisible(NULL))
	}
	if (identical(extract, "no")) {
		open_or_go_to(where_zip, open)
		return(invisible(where_zip))
	}
	where_bundle <- unzip_bundled_html(where_zip, where_bundle)
	cli_progress_update(id = progress_id)
	if (
		identical(delete_zip, "yes") ||
			(identical(delete_zip, "ask") &&
				yesno(sprintf("Delete %s?", fs_path_file(where_zip))))
	) {
		fs_file_delete(where_zip)
	}
	cli_progress_update(id = progress_id)

	open_or_go_to(where_bundle, open)
	invisible(where_bundle)
}
