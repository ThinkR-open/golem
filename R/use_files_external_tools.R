check_url_has_the_correct_extension <- function(
	url,
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
			url
		) !=
			type
	) {
		cli_abort(
			paste0(
				"File not added (URL must end with .",
				type,
				" extension)"
			)
		)
	}
}


download_external <- function(
	url_to_download_from,
	where_to_download
) {
	cat_start_download()
	utils_download_file(
		url_to_download_from,
		where_to_download
	)
	cat_downloaded(
		where_to_download
	)
}

unzip_bundled_html <- function(
	path_from,
	path_to
) {
	cat_start_unzip()
	utils::unzip(
		zipfile = path_from,
		exdir = path_to
	)
	bundle_file_entries <- fs_dir_ls(path_to)
	# the following condition checks: exactly one file/dir exist
	# and what exist is really a dir (not, e.g. index.html)
	if (
		length(bundle_file_entries) == 1 &&
			fs_dir_exists(bundle_file_entries[[1]])
	) {
		# Move one level up when the archive wraps everything in a single dir.
		wrapper_dir <- bundle_file_entries[[1]]
		wrapper_entries <- fs_dir_ls(wrapper_dir, all = TRUE)
		for (entry in wrapper_entries) {
			fs_file_move(
				entry,
				fs_path(path_to, fs_path_file(entry))
			)
		}
		fs_dir_delete(wrapper_dir)
		# When the default target dir is "template", prefer the wrapper dir name.
		if (fs_path_file(path_to) == "template") {
			# make sure that, whenever does not supply a 'name' arg, i.e.,
			# name defaults to "template" **and** there is a top level dir
			# in the bundle itself, use the top-level dir:
			path_new <- fs_path(
				fs_path_dir(path_to),
				fs_path_file(wrapper_dir)
			)
			fs_file_move(path_to, path_new)
			path_to <- path_new
		}
	}
	cat_unzipped(
		path_to,
		"Bundle"
	)
	return(path_to)
}

perform_checks_and_download_if_everything_is_ok <- function(
	url_to_download_from,
	directory_to_download_to,
	file_type,
	file_created_fun,
	golem_wd,
	name,
	open,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
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
	name <- build_name(
		name,
		url_to_download_from
	)
	if (
		is.null(
			file_type
		)
	) {
		where_to_download_to <- fs_path(
			directory_to_download_to,
			name
		)
	} else {
		check_url_has_the_correct_extension(
			url = url_to_download_from,
			file_type
		)
		where_to_download_to <- fs_path(
			directory_to_download_to,
			sprintf(
				"%s.%s",
				name,
				file_type
			)
		)
	}
	check_directory_exists(
		directory_to_download_to
	)
	check_file_exists(
		where_to_download_to
	)
	download_external(
		url_to_download_from = url_to_download_from,
		where_to_download = where_to_download_to
	)
	file_created_dance(
		where = where_to_download_to,
		fun = file_created_fun,
		golem_wd = golem_wd,
		dir = directory_to_download_to,
		open_file = open,
		catfun = NULL
	)
}
