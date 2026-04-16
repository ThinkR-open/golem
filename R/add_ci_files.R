#' Add deployment CI for GitHub Actions
#'
#' Creates a minimal GitHub Actions workflow for deploying a `{golem}` app via
#' `{rsconnect}`. If needed, this function also creates a root `app.R` and
#' `.rscignore` by calling [add_positconnect_file()].
#'
#' @inheritParams add_module
#'
#' @export
#'
#' @return The path to the created workflow, invisibly.
add_github_action <- function(
	golem_wd = get_golem_wd(),
	open = TRUE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)

	add_deploy_ci_(
		template = "github-action-template.yml",
		output = fs_path(
			golem_wd,
			".github",
			"workflows",
			"shiny-deploy.yaml"
		),
		golem_wd = golem_wd,
		open = open
	)
}

#' Add deployment CI for GitLab
#'
#' Creates a minimal GitLab CI file for deploying a `{golem}` app via
#' `{rsconnect}`. If needed, this function also creates a root `app.R` and
#' `.rscignore` by calling [add_positconnect_file()].
#'
#' @inheritParams add_module
#'
#' @export
#'
#' @return The path to the created workflow, invisibly.
add_gitlab_ci <- function(
	golem_wd = get_golem_wd(),
	open = TRUE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)

	add_deploy_ci_(
		template = "gitlab-ci-template.yml",
		output = fs_path(
			golem_wd,
			".gitlab-ci.yml"
		),
		golem_wd = golem_wd,
		open = open
	)
}

add_deploy_ci_ <- function(
	template,
	output,
	golem_wd = get_golem_wd(),
	open = TRUE
) {
	golem_wd <- fs_path_abs(
		golem_wd
	)

	ensure_deploy_entrypoint_(
		golem_wd = golem_wd
	)

	if (
		fs_file_exists(
			output
		)
	) {
		cli_alert_info(
			sprintf(
				"The '%s'-file already exists.",
				basename(
					output
				)
			)
		)
		return(
			open_or_go_to(
				output,
				open
			)
		)
	}

	fs_dir_create(
		path_dir(
			output
		),
		recurse = TRUE
	)

	writeLines(
		render_ci_template_(
			template = template,
			golem_wd = golem_wd
		),
		con = output
	)

	if (
		basename(
			output
		) ==
			"shiny-deploy.yaml"
	) {
		ensure_github_gitignore_(
			golem_wd = golem_wd
		)
		usethis_use_build_ignore(
			".github"
		)
	} else {
		usethis_use_build_ignore(
			".gitlab-ci.yml"
		)
	}

	cat_created(
		output
	)
	open_or_go_to(
		output,
		open
	)
}

render_ci_template_ <- function(
	template,
	golem_wd = get_golem_wd()
) {
	app_name <- get_golem_name(
		golem_wd = golem_wd
	)

	template_lines <- readLines(
		golem_sys(
			"utils",
			template
		),
		warn = FALSE
	)

	gsub(
		"__APPNAME__",
		app_name,
		template_lines,
		fixed = TRUE
	)
}

ensure_deploy_entrypoint_ <- function(
	golem_wd = get_golem_wd()
) {
	app_file <- fs_path(
		golem_wd,
		"app.R"
	)
	rscignore_file <- fs_path(
		golem_wd,
		".rscignore"
	)

	if (
		!fs_file_exists(
			app_file
		)
	) {
		add_positconnect_file(
			golem_wd = golem_wd,
			open = FALSE
		)
		return(
			invisible(
				golem_wd
			)
		)
	}

	if (
		!fs_file_exists(
			rscignore_file
		)
	) {
		add_rscignore_file(
			golem_wd = golem_wd,
			open = FALSE
		)
	}

	invisible(
		golem_wd
	)
}

ensure_github_gitignore_ <- function(
	golem_wd = get_golem_wd()
) {
	where <- fs_path(
		golem_wd,
		".github",
		".gitignore"
	)

	if (
		!fs_file_exists(
			where
		)
	) {
		writeLines(
			"*.html",
			con = where
		)
		return(
			invisible(
				where
			)
		)
	}

	content <- readLines(
		where,
		warn = FALSE
	)

	if (
		!"*.html" %in%
			content
	) {
		writeLines(
			c(
				content,
				"*.html"
			),
			con = where
		)
	}

	invisible(
		where
	)
}

path_dir <- function(path) {
	dirname(path)
}
