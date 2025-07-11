copy_internal_file <- function(
	path,
	where
) {
	cat_start_copy()

	fs_file_copy(
		path,
		where
	)

	cat_copied(
		where
	)
}

check_file_has_the_correct_extension <- function(
	path,
	type = c(
		"js",
		"css",
		"html"
	)
) {
	type <- match.arg(
		type
	)
	if (
		file_ext(
			path
		) !=
			type
	) {
		cli_cli_abort(
			paste0(
				"File not added (URL must end with .",
				type,
				")"
			)
		)
	}
}

perform_checks_and_copy_if_everything_is_ok <- function(
	path_to_copy_from,
	directory_to_copy_to,
	file_type,
	file_created_fun,
	golem_wd,
	name,
	open
) {
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
		is.null(
			file_type
		)
	) {
		name <- build_name(
			name,
			path_to_copy_from,
			with_ext = TRUE
		)
		where_to_copy_to <- fs_path(
			directory_to_copy_to,
			name
		)
	} else {
		name <- build_name(
			name,
			path_to_copy_from
		)
		check_file_has_the_correct_extension(
			path = path_to_copy_from,
			file_type
		)
		where_to_copy_to <- fs_path(
			directory_to_copy_to,
			sprintf(
				"%s.%s",
				name,
				file_type
			)
		)
	}
	check_directory_exists(
		directory_to_copy_to
	)
	check_file_exists(
		where_to_copy_to
	)
	copy_internal_file(
		path_to_copy_from,
		where_to_copy_to
	)
	file_created_dance(
		where = where_to_copy_to,
		fun = after_creation_message_css,
		golem_wd = golem_wd,
		dir = directory_to_copy_to,
		open_file = open,
		catfun = cat_copied
	)
}
