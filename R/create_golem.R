#' Create a package for a Shiny App using `{golem}`
#'
#' @param path Name of the folder to create the package in.
#'     This will also be used as the package name.
#' @param check_name Should we check that the package name is
#'     correct according to CRAN requirements.
#' @param open Boolean. Open the created project?
#' @param overwrite Boolean. Should the already existing project be overwritten ?
#' @param package_name Package name to use. By default, {golem} uses
#'     `basename(path)`. If `path == '.'` & `package_name` is
#'     not explicitly set, then `basename(getwd())` will be used.
#' @param without_comments Boolean. Start project without golem comments
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
#' @importFrom cli cat_rule cat_line
#' @importFrom utils getFromNamespace
#' @importFrom rstudioapi isAvailable openProject hasFun
#' @importFrom usethis use_latest_dependencies create_project
#' @importFrom fs dir_copy
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
	package_name = basename(path),
	without_comments = FALSE,
	project_hook = golem::project_hook,
	with_git = FALSE,
	...
) {
	path <- normalizePath(path, mustWork = FALSE)

	if (check_name) {
		cat_rule("Checking package name")
		getFromNamespace("check_package_name", "usethis")(package_name)
		cat_green_tick("Valid package name")
	}


	if (dir.exists(path)) {
		if (!isTRUE(overwrite)) {
			stop(
				paste(
					"Project directory already exists. \n",
					"Set `create_golem(overwrite = TRUE)` to overwrite anyway.\n",
					"Be careful this will restore a brand new golem. \n",
					"You might be at risk of losing your work !"
				),
				call. = FALSE
			)
		} else {
			cat_red_bullet("Overwriting existing project.")
		}
	} else {
		cat_rule("Creating dir")
		usethis::create_project(
			path = path,
			open = FALSE,
		)
		cat_green_tick("Created package directory")
	}


	cat_rule("Copying package skeleton")
	from <- golem_sys("shinyexample")

	# Copy over whole directory
	dir_copy(path = from, new_path = path, overwrite = TRUE)

	# Listing copied files ***from source directory***
	copied_files <- list.files(
		path = from,
		full.names = FALSE,
		all.files = TRUE,
		recursive = TRUE
	)

	# Going through copied files to replace package name
	for (f in copied_files) {
		copied_file <- file.path(path, f)

		if (grepl("^REMOVEME", f)) {
			file.rename(
				from = copied_file,
				to = file.path(path, gsub("REMOVEME", "", f))
			)
			copied_file <- file.path(path, gsub("REMOVEME", "", f))
		}

		if (!grepl("ico$", copied_file)) {
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

	cat_green_tick("Copied app skeleton")


	cat_rule("Setting the default config")

	yml_path <- file.path(path, "inst/golem-config.yml")
	conf <- yaml::read_yaml(yml_path, eval.expr = TRUE)
	yaml_golem_wd <- "golem::pkg_path()"
	attr(yaml_golem_wd, "tag") <- "!expr"
	conf$dev$golem_wd <- yaml_golem_wd
	conf$default$golem_name <- package_name
	conf$default$golem_version <- "0.0.0.9000"
	write_yaml(conf, yml_path)

	cat_green_tick("Configured app")


	cat_rule("Running project hook function")

	old <- setwd(path)
	# TODO fix
	# for some weird reason test() fails here when using golem::create_golem
	# and I don't have time to search why rn
	if (substitute(project_hook) == "golem::project_hook") {
		project_hook <- getFromNamespace("project_hook", "golem")
	}
	project_hook(path = path, package_name = package_name, ...)
	setwd(old)

	cat_green_tick("All set")


	if (isTRUE(without_comments)) {
		files <- list.files(
			path = c(
				file.path(path, "dev"),
				file.path(path, "R")
			),
			full.names = TRUE
		)
		for (file in files) {
			remove_comments(file)
		}
	}


	if (isTRUE(with_git)) {
		cat_rule("Initializing git repository")
		git_output <- system(
			command = paste("git init", path),
			ignore.stdout = TRUE,
			ignore.stderr = TRUE
		)
		if (git_output) {
			cat_red_bullet("Error initializing git epository")
		} else {
			cat_green_tick("Initialized git repository")
		}
	}


	old <- setwd(path)
	use_latest_dependencies()

	# No .Rprofile for now
	# cat_rule("Appending .Rprofile")
	# write("# Sourcing user .Rprofile if it exists ", ".Rprofile", append = TRUE)
	# write("home_profile <- file.path(", ".Rprofile", append = TRUE)
	# write("  Sys.getenv(\"HOME\"), ", ".Rprofile", append = TRUE)
	# write("  \".Rprofile\"", ".Rprofile", append = TRUE)
	# write(")", ".Rprofile", append = TRUE)
	# write("if (file.exists(home_profile)){", ".Rprofile", append = TRUE)
	# write("  source(home_profile)", ".Rprofile", append = TRUE)
	# write("}", ".Rprofile", append = TRUE)
	# write("rm(home_profile)", ".Rprofile", append = TRUE)
	#
	# write("# Setting shiny.autoload.r to FALSE ", ".Rprofile", append = TRUE)
	# write("options(shiny.autoload.r = FALSE)", ".Rprofile", append = TRUE)
	# cat_green_tick("Appended")

	setwd(old)


	cat_rule("Done")
	cat_line(
		paste0(
			"A new golem named ",
			package_name,
			" was created at ",
			normalizePath(path),
			" .\n",
			"To continue working on your app, start editing the 01_start.R file."
		)
	)


	if (isTRUE(open)) {
		if (rstudioapi::isAvailable() & rstudioapi::hasFun("openProject")) {
			rstudioapi::openProject(path = path)
		} else {
			setwd(path)
		}
	}


	return(
		invisible(
			normalizePath(path)
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
	splt <- strsplit(dots$project_hook, "::")
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
