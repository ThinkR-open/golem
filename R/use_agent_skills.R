#' Add Agent Skills to a golem Project
#'
#' @param source Where to install agent skills from. Use `"ask"` for the
#'   interactive menu.
#' @param agent_specs Which agent specifications to install. Use `"ask"` for the
#'   interactive menu.
#' @param skills Skills to install. Use `NULL` for the interactive selector, or
#'   `"all"` to install all available skills.
#' @param overwrite How to handle existing files. Use `"ask"` for the
#'   interactive menu.
#' @param golem_wd Path to the golem project where files should be copied.
#'
#' @return A list of selected options and copied paths, invisibly.
#' @export
use_agent_skills <- function(
	source = c("ask", "local", "remote"),
	agent_specs = c("ask", "claude", "agents", "both"),
	skills = NULL,
	overwrite = c("ask", "overwrite", "skip", "abort"),
	golem_wd = get_golem_wd()
) {
	source <- match.arg(source)
	agent_specs <- match.arg(agent_specs)
	overwrite <- match.arg(overwrite)

	if (identical(source, "ask")) source <- ask_agent_skills_source()
	# early return if user cancels interaction
	if (is.null(source)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}

	if (identical(source, "local")) {
		root <- get_agent_skills_golem_root()
		manifest <- get_agent_skills_manifest(root)
	}
	if (identical(source, "remote")) {
		root <- get_agent_skills_golem_github()
		manifest <- get_agent_skills_manifest(root)
	}
	if (is.null(manifest)) {
		cli_abort(sprintf("Could not read manifest from source %s.", source))
	}

	if (identical(agent_specs, "ask")) agent_specs <- ask_agent_skills_specs()
	if (is.null(agent_specs)) {
		cli_alert_warning("Abort selection.")
		return(invisible(NULL))
	}
	selected_agent_specs <- switch(
		agent_specs,
		claude = "claude",
		agents = "agents",
		both = c("claude", "agents"),
		NULL
	)

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

	copied <- copy_agent_skills(
		source = source,
		root = root,
		manifest = manifest,
		selected_agent_specs = selected_agent_specs,
		skills = skills,
		overwrite = overwrite,
		golem_wd = golem_wd
	)

	if (is.null(copied)) return(invisible(NULL))

	choices <- list(
		source = source,
		agent_specs = agent_specs,
		selected_agent_specs = selected_agent_specs,
		skills = skills,
		overwrite = overwrite,
		root = root,
		copied = copied
	)

	invisible(choices)
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

	url <- sprintf(
		"https://github.com/%s/archive/refs/heads/%s.zip",
		repo,
		ref
	)

	utils_download_file(url, archive, quiet = TRUE)
	utils::unzip(archive, exdir = extract_dir)

	roots <- list.dirs(extract_dir, recursive = FALSE, full.names = TRUE)
	if (!length(roots)) {
		cli_abort(sprintf("Could not extract agent skills from %s.", url))
	}

	roots[[1]]
}

get_agent_skills_manifest <- function(root) {
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

ask_agent_skills_specs <- function() {
	choice <- utils_menu(
		c(
			"Only CLAUDE specifications.",
			"Only AGENTS specifications.",
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

copy_agent_skills <- function(
	source,
	root,
	manifest,
	selected_agent_specs,
	skills,
	overwrite,
	golem_wd
) {
	copied <- character()

	for (agent_spec in selected_agent_specs) {
		settings <- manifest$settings[[agent_spec]]

		copied_file <- copy_agent_skill_path(
			source = file.path(root, settings$main_file_name),
			target = file.path(golem_wd, settings$main_file_name),
			overwrite = overwrite,
			type = "file"
		)
		if (is.null(copied_file)) return(NULL)
		copied <- c(copied, copied_file)

		for (skill in skills) {
			copied_dir <- copy_agent_skill_path(
				source = get_agent_skill_source_dir(
					source = source,
					root = root,
					settings = settings,
					skill = skill
				),
				target = file.path(golem_wd, settings$path, skill),
				overwrite = overwrite,
				type = "dir"
			)
			if (is.null(copied_dir)) return(NULL)
			copied <- c(copied, copied_dir)
		}
	}

	copied[!is.na(copied)]
}

get_agent_skill_source_dir <- function(
	source,
	root,
	settings,
	skill
) {
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

	if (file.exists(target)) {
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
		if (identical(action, "skip")) return(NA_character_)
	}

	fs_dir_create(dirname(target))

	if (identical(type, "file")) {
		fs_file_copy(source, target, overwrite = TRUE)
	} else {
		fs_dir_copy(source, target, overwrite = TRUE)
	}

	target
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
