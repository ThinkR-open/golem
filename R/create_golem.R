replace_package_name <- function(
	copied_files,
	package_name,
	path_to_golem
) {
	# Going through copied files to replace package name
	for (f in copied_files) {
		copied_file <- file.path(
			path_to_golem,
			f
		)

		if (
			grepl(
				"^REMOVEME",
				f
			)
		) {
			file.rename(
				from = copied_file,
				to = file.path(
					path_to_golem,
					gsub(
						"REMOVEME",
						"",
						f
					)
				)
			)
			copied_file <- file.path(
				path_to_golem,
				gsub(
					"REMOVEME",
					"",
					f
				)
			)
		}

		if (
			!grepl(
				"ico$",
				copied_file
			)
		) {
			try(
				{
					replace_word(
						file = copied_file,
						pattern = "shinyexample",
						replace = package_name
					)
				},
				silent = TRUE
			)
		}
	}
}

copy_golem_skeleton_and_replace_name <- function(
	path_to_golem,
	package_name
) {
	cli_cat_rule(
		"Copying package skeleton"
	)
	from <- golem_sys(
		"shinyexample"
	)

	# Copy over whole directory
	fs_dir_copy(
		path = from,
		new_path = path_to_golem,
		overwrite = TRUE
	)

	# Listing copied files ***from source directory***
	copied_files <- list.files(
		path = from,
		full.names = FALSE,
		all.files = TRUE,
		recursive = TRUE
	)

	replace_package_name(
		copied_files,
		package_name,
		path_to_golem
	)
	cat_green_tick(
		"Copied app skeleton"
	)
}

#' Create a package for a Shiny App using `{golem}`
#'
#' @param path Name of the folder to create the package in.
#'     This will also be used as the package name.
#' @param check_name Should we check that the package name is
#'     correct according to CRAN requirements.
#' @param open Boolean. Open the created project?
#' @param overwrite Boolean. Should the already existing project be deleted and replaced?
#' @param package_name Package name to use. By default, `{golem}` uses
#'     `basename(path)`. If `path == '.'` & `package_name` is
#'     not explicitly set, then `basename(getwd())` will be used.
#' @param without_comments Boolean. Start project without `{golem}` comments
#' @param project_hook A function executed as a hook after project
#'     creation. Can be used to change the default `{golem}` structure.
#'     to override the files and content. This function is executed just
#'     after the project is created.
#' @param with_git Boolean. Initialize git repository
#' @param ... Arguments passed to the `project_hook()` function.
#'
#' @note
#' For compatibility issue, this function turns `options(shiny.autoload.r)`
#' to `FALSE`. See https://github.com/ThinkR-open/golem/issues/468 for more background.
#'
#' @importFrom utils getFromNamespace
#' @importFrom yaml write_yaml
#'
#' @export
#'
#' @return The path, invisibly.
create_golem <- function(
	path,
	check_name = TRUE,
	open = TRUE,
	overwrite = FALSE,
	package_name = basename(
		normalizePath(
			path,
			mustWork = FALSE
		)
	),
	without_comments = FALSE,
	project_hook = golem::project_hook,
	with_git = FALSE,
	...
) {
	path_to_golem <- normalizePath(
		path,
		mustWork = FALSE
	)

	if (check_name) {
		cli_cat_rule(
			"Checking package name"
		)
		rlang::check_installed(
			"usethis",
			version = "1.6.0",
			reason = "to check the package name."
		)
		getFromNamespace(
			"check_package_name",
			"usethis"
		)(
			package_name
		)
		cat_green_tick(
			"Valid package name"
		)
	}

	if (
		fs_dir_exists(
			path_to_golem
		)
	) {
		if (
			!isTRUE(
				overwrite
			)
		) {
			stop(
				paste(
					"The directory already exists.\n",
					"Set `create_golem(overwrite = TRUE)` to delete and replace.\n",
					"Be careful this will delete the old folder.\n",
					"You might be at risk of losing your work!"
				),
				call. = FALSE
			)
		} else {
			cat_green_tick(
				"Deleting existing project."
			)
			fs_dir_delete(
				path_to_golem
			)
		}
	}

	copy_golem_skeleton_and_replace_name(
		path_to_golem,
		package_name
	)

	old <- setwd(
		path_to_golem
	)

	cli_cat_rule(
		"Running project hook function"
	)

	# TODO fix
	# for some weird reason test() fails here when using golem::create_golem
	# and I don't have time to search why rn
	if (
		substitute(
			project_hook
		) ==
			"golem::project_hook"
	) {
		project_hook <- getFromNamespace(
			"project_hook",
			"golem"
		)
	}
	project_hook(
		path = path_to_golem,
		package_name = package_name,
		...
	)

	setwd(
		old
	)

	cat_green_tick
	("All set")

	if (
		isTRUE(
			without_comments
		)
	) {
		files <- list.files(
			path = c(
				file.path(
					path_to_golem,
					"dev"
				),
				file.path(
					path_to_golem,
					"R"
				)
			),
			full.names = TRUE
		)
		for (file in files) {
			remove_comments(
				file
			)
		}
	}

	if (
		isTRUE(
			with_git
		)
	) {
		cli_cat_rule(
			"Initializing git repository"
		)
		git_output <- system(
			command = paste(
				"git init",
				path_to_golem
			),
			ignore.stdout = TRUE,
			ignore.stderr = TRUE
		)
		if (git_output) {
			cat_red_bullet(
				"Error initializing git repository"
			)
		} else {
			cat_green_tick(
				"Initialized git repository"
			)
		}
	}

	setwd(
		old
	)

	cli_cat_rule(
		"Done"
	)

	cli_cat_line(
		paste0(
			"A new golem named ",
			package_name,
			" was created at ",
			path_to_golem,
			" .\n",
			"To continue working on your app, start editing the 01_start.R file."
		)
	)

	check_dev_deps_are_installed()

	if (
		isTRUE(
			open
		)
	) {
		if (
			rlang::is_installed(
				"rstudioapi"
			) &&
				rstudioapi::isAvailable() &&
				rstudioapi::hasFun(
					"openProject"
				)
		) {
			rstudioapi::openProject(
				path = path
			)
		} else {
			setwd(
				path
			)
		}
	}

	return(
		invisible(
			path_to_golem
		)
	)
}

# to be used in RStudio "new project" GUI
create_golem_gui <- function(path, ...) {
	dots <- list(...)
	attempt::stop_if_not(
		dots$project_hook,
		~ grepl("::", .x),
		"{golem} project templates must be explicitely namespaced (pkg::fun)"
	)
	splt <- strsplit(
		dots$project_hook,
		"::"
	)
	project_hook <- getFromNamespace(
		splt[[1]][2],
		splt[[1]][1]
	)
	create_golem(
		path = path,
		open = FALSE,
		without_comments = dots$without_comments,
		project_hook = project_hook,
		check_name = dots$check_name,
		with_git = dots$with_git
	)
}
