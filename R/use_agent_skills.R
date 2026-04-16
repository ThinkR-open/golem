#' Implement Agent Skills in a golem Project
#'
#' @param source Where to install agent skills from. Use `"ask"` for the
#'   interactive menu.
#' @param agent_specs Which agent specifications to install. Use `"ask"` for the
#'   interactive menu.
#' @param skills Skills to install. Use `NULL` for the interactive selector, or
#'   `"all"` to install all available skills.
#' @param main_md_files Whether to also add `AGENTS.md` / `CLAUDE.md`. Use
#'   `"ask"` for the interactive menu.
#' @param overwrite How to handle existing files. Use `"ask"` for the
#'   interactive menu.
#' @param golem_wd Path to the golem project where files should be copied.
#'
#' @seealso [use_skills()], [use_agent_skills()], [use_claude_skills()],
#'   [use_skill()]
#'
#' @keywords internal
#'
#' @return A list of selected options and copied paths, invisibly.
use_agent_implement <- function(
	source = c("ask", "local", "remote"),
	agent_specs = c("ask", "claude", "agents", "both"),
	skills = NULL,
	main_md_files = c("ask", "yes", "no"),
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	source <- match.arg(source)
	agent_specs <- match.arg(agent_specs)
	main_md_files <- match.arg(main_md_files)
	overwrite <- match.arg(overwrite)

	if (identical(source, "ask")) source <- ask_agent_skills_source()
	if (is.null(source)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}

	if (identical(source, "local")) {
		root <- get_agent_skills_golem_root()
		manifest <- get_agent_skills_golem_manifest(root)
	}
	if (identical(source, "remote")) {
		manifest <- get_agent_skills_github_manifest()
	}
	if (is.null(manifest)) {
		cli_abort(sprintf("Could not read manifest from source %s.", source))
	}
	settings <- get_agent_skills_settings(manifest)

	if (identical(agent_specs, "ask")) agent_specs <- ask_agent_skills_specs()
	if (is.null(agent_specs)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}
	selected_agent_specs <- normalize_agent_skills_specs(
		agent_specs = agent_specs,
		settings = settings
	)
	copy_main_files <- normalize_agent_skills_main_files(
		main_md_files = main_md_files,
		selected_agent_specs = selected_agent_specs,
		settings = settings
	)
	if (is.null(copy_main_files)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}

	if (is.null(skills)) {
		skills <- ask_agent_skills_selection(manifest$skills_available)
	} else {
		skills <- normalize_agent_skills_argument(
			skills = skills,
			skills_available = manifest$skills_available
		)
	}
	if (is.null(skills)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}

	if (identical(source, "remote")) {
		remote_source <- get_agent_skills_golem_github()
		root <- remote_source$root
		on.exit(
			unlink(remote_source$cleanup, recursive = TRUE, force = TRUE),
			add = TRUE
		)
	}

	copied <- copy_agent_skills(
		source = source,
		root = root,
		manifest = manifest,
		settings = settings,
		selected_agent_specs = selected_agent_specs,
		skills = skills,
		overwrite = overwrite,
		golem_wd = golem_wd,
		copy_main_files = copy_main_files
	)

	if (is.null(copied)) return(invisible(NULL))

	invisible(
		list(
			source = source,
			agent_specs = agent_specs,
			selected_agent_specs = selected_agent_specs,
			skills = skills,
			main_md_files = main_md_files,
			overwrite = overwrite,
			root = root,
			copied = copied
		)
	)
}

#' Add Skills to a golem Project
#'
#' @inheritParams use_agent_implement
#'
#' @seealso [use_agent_implement()], [use_agent_skills()],
#'   [use_claude_skills()], [use_skill()]
#'
#' @return A list of selected options and copied paths, invisibly.
#' @export
use_skills <- function(
	source = c("ask", "local", "remote"),
	agent_specs = c("ask", "claude", "agents", "both"),
	skills = NULL,
	main_md_files = c("ask", "yes", "no"),
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	use_agent_implement(
		source = source,
		agent_specs = agent_specs,
		skills = skills,
		main_md_files = main_md_files,
		overwrite = overwrite,
		golem_wd = golem_wd
	)
}

#' Add Agent Skills to a golem Project
#'
#' @inheritParams use_agent_implement
#'
#' @seealso [use_skills()], [use_agent_implement()], [use_claude_skills()],
#'   [use_skill()]
#'
#' @return A list of selected options and copied paths, invisibly.
#' @export
use_agent_skills <- function(
	source = c("ask", "local", "remote"),
	skills = NULL,
	main_md_files = c("ask", "yes", "no"),
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	use_agent_implement(
		source = source,
		agent_specs = "agents",
		skills = skills,
		main_md_files = main_md_files,
		overwrite = overwrite,
		golem_wd = golem_wd
	)
}

#' Add Claude Skills to a golem Project
#'
#' @inheritParams use_agent_implement
#'
#' @seealso [use_skills()], [use_agent_implement()], [use_agent_skills()],
#'   [use_skill()]
#'
#' @return A list of selected options and copied paths, invisibly.
#' @export
use_claude_skills <- function(
	source = c("ask", "local", "remote"),
	skills = NULL,
	main_md_files = c("ask", "yes", "no"),
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	use_agent_implement(
		source = source,
		agent_specs = "claude",
		skills = skills,
		main_md_files = main_md_files,
		overwrite = overwrite,
		golem_wd = golem_wd
	)
}

#' Add a Single Skill to Installed Agent Specifications
#'
#' @param name Skill name to install.
#' @param source Where to install agent skills from. If `NULL`, prompt
#'   interactively.
#' @param overwrite How to handle existing files. Use `"ask"` for the
#'   interactive menu.
#' @param golem_wd Path to the golem project where files should be copied.
#'
#' @seealso [use_skills()], [use_agent_implement()], [use_agent_skills()],
#'   [use_claude_skills()]
#'
#' @return A list of selected options and copied paths, invisibly.
#' @export
use_skill <- function(
	name,
	source = NULL,
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	if (missing(name) || length(name) != 1 || !nzchar(name)) {
		cli_abort("`name` must be a single non-empty skill name.")
	}

	if (is.null(source)) source <- "ask"
	source <- match.arg(source, c("ask", "local", "remote"))
	overwrite <- match.arg(overwrite)

	if (identical(source, "ask")) source <- ask_agent_skills_source()
	if (is.null(source)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}

	if (identical(source, "local")) {
		root <- get_agent_skills_golem_root()
		manifest <- get_agent_skills_golem_manifest(root)
	}
	if (identical(source, "remote")) {
		remote_source <- get_agent_skills_golem_github()
		root <- remote_source$root
		on.exit(
			unlink(remote_source$cleanup, recursive = TRUE, force = TRUE),
			add = TRUE
		)
		manifest <- get_agent_skills_golem_manifest(root)
	}
	if (is.null(manifest)) {
		cli_abort(sprintf("Could not read manifest from source %s.", source))
	}
	settings <- get_agent_skills_settings(manifest)
	skills <- normalize_agent_skills_argument(
		skills = name,
		skills_available = manifest$skills_available
	)
	selected_agent_specs <- get_installed_agent_skills_specs(
		golem_wd = golem_wd,
		settings = settings
	)

	copied <- copy_agent_skills(
		source = source,
		root = root,
		manifest = manifest,
		settings = settings,
		selected_agent_specs = selected_agent_specs,
		skills = skills,
		overwrite = overwrite,
		golem_wd = golem_wd,
		copy_main_files = FALSE
	)

	if (is.null(copied)) return(invisible(NULL))

	invisible(
		list(
			source = source,
			agent_specs = selected_agent_specs,
			skills = skills,
			overwrite = overwrite,
			root = root,
			copied = copied
		)
	)
}

get_agent_skills_golem_root <- function() {
	root <- golem_sys("agent-skills", mustWork = FALSE)
	if (nzchar(root)) return(root)
	file.path("inst", "agent-skills")
}

get_agent_skills_golem_github <- function(
	repo = "ilyaZar/golem-agent-skills",
	ref = "main"
) {
	archive <- tempfile(fileext = ".zip")
	extract_dir <- tempfile("golem-agent-skills-")
	dir.create(extract_dir)
	progress_id <- cli_progress_bar(
		name = "Fetching remote agent skills",
		total = 3,
		type = "tasks"
	)
	on.exit(cli_progress_done(id = progress_id), add = TRUE)

	url <- sprintf(
		"https://github.com/%s/archive/refs/heads/%s.zip",
		repo,
		ref
	)

	utils_download_file(url, archive, quiet = TRUE)
	cli_progress_update(id = progress_id)
	utils::unzip(archive, exdir = extract_dir)
	cli_progress_update(id = progress_id)

	roots <- list.dirs(extract_dir, recursive = FALSE, full.names = TRUE)
	if (!length(roots)) {
		cli_abort(sprintf("Could not extract agent skills from %s.", url))
	}
	cli_progress_update(id = progress_id)

	list(
		root = roots[[1]],
		cleanup = c(archive, extract_dir)
	)
}

get_agent_skills_github_manifest <- function(
	repo = "ilyaZar/golem-agent-skills",
	ref = "main"
) {
	manifest_file <- tempfile(fileext = ".yml")
	on.exit(unlink(manifest_file, force = TRUE), add = TRUE)

	url <- sprintf(
		"https://raw.githubusercontent.com/%s/%s/manifest.yml",
		repo,
		ref
	)

	utils_download_file(url, manifest_file, quiet = TRUE)
	yaml::read_yaml(manifest_file)
}

get_agent_skills_golem_manifest <- function(root) {
	manifest_path <- file.path(root, "manifest.yml")
	if (!file.exists(manifest_path)) {
		cli_abort(sprintf("Agent skills manifest not found at %s.", manifest_path))
	}
	yaml::read_yaml(manifest_path)
}

ask_agent_skills_source <- function() {
	choice <- utils_menu(
		c(
			"Locally from the {golem} package (no internet required).",
			"Remote from ilyaZar/golem-agent-skills (internet required).",
			"Cancel."
		),
		title = "Decide on the source to take the agent skills from:"
	)

	switch(
		choice,
		"1" = "local",
		"2" = "remote",
		"3" = NULL,
		NULL
	)
}

ask_agent_skills_main_files <- function(
	selected_agent_specs,
	settings
) {
	main_files <- vapply(
		selected_agent_specs,
		function(agent_spec) settings[[agent_spec]]$main_file_name,
		character(1)
	)

	title <- switch(
		length(main_files),
		"1" = sprintf(
			"Do you also want to add '%s'?",
			main_files[[1]]
		),
		sprintf(
			"Do you also want to add %s files?",
			paste(sprintf("'%s'", main_files), collapse = " and ")
		)
	)

	choice <- utils_menu(
		c(
			"Yes.",
			"No.",
			"Cancel."
		),
		title = title
	)

	switch(
		choice,
		"1" = TRUE,
		"2" = FALSE,
		"3" = NULL,
		NULL
	)
}

ask_agent_skills_overwrite <- function(target) {
	choice <- utils_menu(
		c(
			"Overwrite.",
			"Skip.",
			"Cancel."
		),
		title = sprintf("%s already exists.\nWhat do you want to do?", target)
	)

	switch(
		choice,
		"1" = "overwrite",
		"2" = "skip",
		"3" = "cancel",
		"cancel"
	)
}
ask_agent_skills_specs <- function() {
	choice <- utils_menu(
		c(
			"Only CLAUDE specifications.",
			"Only OpenAI AGENTS (.agents) specifications.",
			"Both.",
			"Cancel."
		),
		title = "Which specifications do you want to install?"
	)

	switch(
		choice,
		"1" = "claude",
		"2" = "agents",
		"3" = "both",
		"4" = NULL,
		NULL
	)
}

ask_agent_skills_selection <- function(skills) {
	selected <- utils::select.list(
		choices = c(skills, "All.", "Cancel."),
		multiple = TRUE,
		title = "Select agent skills to install:",
		graphics = FALSE
	)

	normalize_agent_skills_selection(
		selected = selected,
		skills = skills
	)
}

get_agent_skills_settings <- function(manifest) {
	settings <- manifest$targets %||% manifest$settings
	if (is.null(settings)) {
		cli_abort("Agent skills manifest must define either `targets` or `settings`.")
	}

	settings
}

normalize_agent_skills_specs <- function(
	agent_specs,
	settings
) {
	selected <- switch(
		agent_specs,
		claude = "claude",
		agents = "agents",
		both = c("claude", "agents"),
		NULL
	)

	missing_specs <- setdiff(unique(selected), names(settings))
	if (length(missing_specs)) {
		cli_abort(
			sprintf(
				"Agent skills manifest is missing target(s): %s.",
				paste(missing_specs, collapse = ", ")
			)
		)
	}

	unique(selected)
}


normalize_agent_skills_main_files <- function(
	main_md_files,
	selected_agent_specs,
	settings
) {
	switch(
		main_md_files,
		ask = ask_agent_skills_main_files(
			selected_agent_specs = selected_agent_specs,
			settings = settings
		),
		yes = TRUE,
		no = FALSE,
		NULL
	)
}

normalize_agent_skills_selection <- function(
	selected,
	skills
) {
	if (!length(selected) || "Cancel." %in% selected) return(NULL)

	if ("All." %in% selected) return(skills)

	selected
}

normalize_agent_skills_argument <- function(
	skills,
	skills_available
) {
	if (
		length(skills) == 1 &&
		tolower(skills) == "all"
	) {
		return(skills_available)
	}

	unknown_skills <- setdiff(skills, skills_available)
	if (length(unknown_skills)) {
		cli_abort(
			sprintf(
				"Unknown agent skill(s): %s.",
				paste(unknown_skills, collapse = ", ")
			)
		)
	}

	skills
}

get_installed_agent_skills_specs <- function(
	golem_wd,
	settings
) {
	target_specs <- intersect(c("claude", "agents"), names(settings))
	installed <- Filter(
		function(agent_spec) {
			dir.exists(file.path(golem_wd, settings[[agent_spec]]$path))
		},
		target_specs
	)

	if (!length(installed)) {
		expected_dirs <- vapply(
			target_specs,
			function(agent_spec) file.path(golem_wd, settings[[agent_spec]]$path),
			character(1)
		)
		cli_abort(
			sprintf(
				paste(
					"No installed agent specifications found in %s.",
					"Expected an existing %s directory."
				),
				golem_wd,
				paste(expected_dirs, collapse = " or ")
			)
		)
	}

	installed
}

copy_agent_skills <- function(
	source,
	root,
	manifest,
	settings,
	selected_agent_specs,
	skills,
	overwrite,
	golem_wd,
	copy_main_files = TRUE
) {
	entries <- list()

	for (agent_spec in selected_agent_specs) {
		spec_settings <- settings[[agent_spec]]

		if (isTRUE(copy_main_files)) {
			entries[[length(entries) + 1]] <- list(
				source = file.path(root, spec_settings$main_file_name),
				target = file.path(golem_wd, spec_settings$main_file_name),
				type = "file"
			)
		}

		for (skill in skills) {
			entries[[length(entries) + 1]] <- list(
				source = get_agent_skill_source_dir(
					source = source,
					root = root,
					manifest = manifest,
					settings = spec_settings,
					skill = skill
				),
				target = file.path(golem_wd, spec_settings$path, skill),
				type = "dir"
			)
		}
	}

	copied <- character()
	progress_id <- cli_progress_bar(
		name = "Copying agent skills",
		total = length(entries)
	)
	on.exit(cli_progress_done(id = progress_id), add = TRUE)

	for (entry in entries) {
		copied_entry <- copy_agent_skill_path(
			source = entry$source,
			target = entry$target,
			overwrite = overwrite,
			type = entry$type
		)
		if (is.null(copied_entry)) return(NULL)
		copied <- c(copied, copied_entry)
		cli_progress_update(id = progress_id)
	}

	copied[!is.na(copied)]
}

resolve_agent_skill_overwrite <- function(
	target,
	overwrite = c("ask", "overwrite", "skip", "abort")
) {
	overwrite <- match.arg(overwrite)

	if (!file.exists(target)) {
		return(overwrite)
	}

	action <- switch(
		overwrite,
		ask = ask_agent_skills_overwrite(target),
		overwrite = "overwrite",
		skip = "skip",
		abort = cli_abort(sprintf("Agent skill target already exists at %s.", target))
	)

	if (identical(action, "cancel")) {
		cli_alert_warning("Abort selection.")
		return(NULL)
	}

	action
}

get_agent_skill_source_dir <- function(
	source,
	root,
	manifest,
	settings,
	skill
) {
	if (!is.null(settings$source_path)) {
		return(file.path(root, settings$source_path, skill))
	}

	if (!is.null(manifest$skills_root)) {
		return(file.path(root, manifest$skills_root, skill))
	}

	switch(
		source,
		local = file.path(root, "skills", skill),
		remote = file.path(root, settings$path, skill),
		cli_abort(sprintf("Unsupported agent skill source %s.", source))
	)
}

copy_agent_skill_path <- function(
	source,
	target,
	overwrite = c("ask", "overwrite", "skip", "abort"),
	type = c("file", "dir")
) {
	overwrite <- match.arg(overwrite)
	type <- match.arg(type)

	if (!file.exists(source)) {
		cli_abort(sprintf("Agent skill source not found at %s.", source))
	}

	action <- resolve_agent_skill_overwrite(
		target = target,
		overwrite = overwrite
	)
	if (is.null(action)) return(NULL)
	if (identical(action, "skip")) return(NA_character_)

	fs_dir_create(dirname(target))

	if (identical(type, "file")) {
		fs_file_copy(source, target, overwrite = TRUE)
	} else {
		fs_dir_copy(source, target, overwrite = TRUE)
	}

	target
}
