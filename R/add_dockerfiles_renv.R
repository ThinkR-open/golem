add_dockerfile_with_renv_ <- function(
	golem_wd = get_golem_wd(),
	lockfile = NULL,
	output_dir = fs::path(
		tempdir(),
		"deploy"
	),
	distro = "focal",
	FROM = "rocker/verse",
	AS = "builder",
	sysreqs = TRUE,
	repos = c(
		CRAN = "https://cran.rstudio.com/"
	),
	expand = FALSE,
	extra_sysreqs = NULL,
	update_tar_gz = TRUE,
	document = FALSE,
	single_file = FALSE,
	...,
	source_folder
) {
	signal_arg_is_deprecated(
		source_folder,
		fun = as.character(sys.call()[[1]]),
		"source_folder"
	)

	check_dockerfiler_installed()

	if (is.null(lockfile)) {
		rlang::check_installed(
			c("renv", "attachment"),
			reason = "to build a Dockerfile with automatic renv.lock creation. Use the `lockfile` parameter to pass your own `renv.lock` file."
		)
	}

	# Small hack to prevent warning from rlang::lang() in tests
	# This should be managed in {attempt} later on
	x <- suppressWarnings({
		rlang::lang(print)
	})
	dir.create(output_dir, showWarnings = {
		!getOption(
			"golem.quiet",
			getOption(
				"usethis.quiet",
				default = FALSE
			)
		)
	})

	# add output_dir in Rbuildignore if the output is inside the golem
	if (normalizePath(dirname(output_dir)) == normalizePath(golem_wd)) {
		usethis_use_build_ignore(output_dir)
	}

	if (is.null(lockfile)) {
		if (isTRUE(document)) {
			cli_cat_line(
				"You set `document = TRUE` and you did not pass your own renv.lock file,"
			)
			cli_cat_line(
				"as a consequence {golem} will use `attachment::att_amend_desc()` to update your "
			)
			cli_cat_line("DESCRIPTION file before creating the renv.lock file")
			cli_cat_line("")
			cli_cat_line(
				"you can set `document = FALSE` to use your actual DESCRIPTION file,"
			)
			cli_cat_line(
				"or pass you own renv.lock to use, using the `lockfile` parameter"
			)
			cli_cat_line("")
			cli_cat_line(
				"In any case be sure to have no Error or Warning at `devtools::check()`"
			)
		}

		lockfile <- attachment_create_renv_for_prod(
			path = golem_wd,
			check_if_suggests_is_installed = FALSE,
			document = document,
			output = file.path(
				output_dir,
				"renv.lock.prod"
			),
			...
		)
	}
	file.copy(
		from = lockfile,
		to = output_dir
	)

	socle <- dockerfiler_dock_from_renv(
		lockfile = lockfile,
		distro = distro,
		FROM = FROM,
		repos = repos,
		AS = AS,
		sysreqs = sysreqs,
		expand = expand,
		extra_sysreqs = extra_sysreqs
	)

	if (!single_file) {
		socle$write(
			as = file.path(
				output_dir,
				"Dockerfile_base"
			)
		)

		my_dock <- dockerfiler_Dockerfile()$new(
			FROM = tolower(
				tolower(
					paste0(
						get_golem_name(
							golem_wd = golem_wd
						),
						"_base"
					)
				)
			)
		)
	} else {
		# ici on va faire le fork
		# et ici faut append

		my_dock <- dockerfiler_Dockerfile()$new(
			FROM = AS,
			AS = "final"
		)

		socle$write(
			as = file.path(
				output_dir,
				"Dockerfile"
			)
		)
	}

	if (!single_file) {
		my_dock$COPY(basename(lockfile), "renv.lock")
		my_dock$RUN(
			"R -e 'options(renv.config.pak.enabled = FALSE);renv::restore()'"
		)
	}
	# we use an already built tar.gz file
	my_dock$COPY(
		from = paste0(
			get_golem_name(
				golem_wd = golem_wd
			),
			"_*.tar.gz"
		),
		to = "/app.tar.gz"
	)
	my_dock$RUN(
		"R -e 'remotes::install_local(\"/app.tar.gz\",upgrade=\"never\")'"
	)
	my_dock$RUN("rm /app.tar.gz")

	if (update_tar_gz) {
		old_version <- list.files(
			path = output_dir,
			pattern = paste0(
				get_golem_name(
					golem_wd = golem_wd
				),
				"_*.*.tar.gz"
			),
			full.names = TRUE
		)
		if (length(old_version) > 0) {
			lapply(old_version, file.remove)
			lapply(old_version, unlink, force = TRUE)
			cat_red_bullet(
				sprintf(
					"%s were removed from folder",
					paste(
						old_version,
						collapse = ", "
					)
				)
			)
		}

		if (
			isTRUE(
				requireNamespace(
					"pkgbuild",
					quietly = TRUE
				)
			)
		) {
			out <- pkgbuild::build(
				path = golem_wd,
				dest_path = output_dir,
				vignettes = FALSE,
				quiet = {
					getOption(
						"golem.quiet",
						getOption(
							"usethis.quiet",
							default = FALSE
						)
					)
				}
			)
			if (missing(out)) {
				cat_red_bullet("Error during tar.gz building")
			} else {
				cat_green_tick(
					sprintf(
						" %s created.",
						out
					)
				)
			}
		} else {
			stop("please install {pkgbuild}")
		}
	}

	my_dock
}

#' @param golem_wd path to the Package/golem source folder to deploy.
#' default is retrieved via [get_golem_wd()].
#' @param lockfile path to the renv.lock file to use. default is `NULL`.
#' @param output_dir folder to export everything deployment related.
#' @param distro One of "focal", "bionic", "xenial", "centos7", or "centos8".
#' See available distributions at https://hub.docker.com/r/rstudio/r-base/.
#' @param document boolean. If TRUE (by default), DESCRIPTION file is updated using [attachment::att_amend_desc()] before creating the renv.lock file
#' @param dockerfile_cmd What is the CMD to add to the Dockerfile. If NULL, the default,
#' the CMD will be `R -e "options('shiny.port'={port},shiny.host='{host}',golem.app.prod = {set_golem.app.prod});library({appname});{appname}::run_app()\`.
#' @param user Name of the user to specify in the Dockerfile with the USER instruction. Default is `rstudio`, if set to `NULL` no the user from the FROM image is used.
#' @param single_file boolean.
#'   If `TRUE` (by default), generate a single multi-stage Dockerfile .
#'   If `FALSE`, produce two distinct Dockerfiles to be run sequentially
#'   for the build and production phases.
#' @param set_golem.app.prod boolean If `TRUE` (by default) set options(golem.app.prod = TRUE) in dockerfile_cmd.
#' @param ... Other arguments to pass to [renv::snapshot()].
#' @param source_folder deprecated, use golem_wd instead
#' @inheritParams add_dockerfile
#' @rdname dockerfiles
#' @export
add_dockerfile_with_renv <- function(
	golem_wd = get_golem_wd(),
	lockfile = NULL,
	output_dir = fs::path(tempdir(), "deploy"),
	distro = "focal",
	from = "rocker/verse",
	as = "builder",
	sysreqs = TRUE,
	port = 80,
	host = "0.0.0.0",
	repos = c(CRAN = "https://cran.rstudio.com/"),
	expand = FALSE,
	open = TRUE,
	document = TRUE,
	extra_sysreqs = NULL,
	update_tar_gz = TRUE,
	dockerfile_cmd = NULL,
	user = "rstudio",
	single_file = TRUE,
	set_golem.app.prod = TRUE,
	...,
	source_folder
) {
  signal_arg_is_deprecated(
    source_folder,
    fun = as.character(sys.call()[[1]]),
    "source_folder"
  )

  base_dock <- add_dockerfile_with_renv_(
    golem_wd = golem_wd,
    lockfile = lockfile,
    output_dir = output_dir,
    distro = distro,
    FROM = from,
    AS = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    extra_sysreqs = extra_sysreqs,
    update_tar_gz = update_tar_gz,
    document = document,
    single_file = single_file,
    ...
  )
  if (!is.null(port)) {
    base_dock$EXPOSE(port)
  }
  if (!is.null(user)) {
    base_dock$USER(user)
  }
  if (is.null(dockerfile_cmd)) {
    dockerfile_cmd <- sprintf(
      "R -e \"options('shiny.port'=%s,shiny.host='%s',golem.app.prod=%s);library(%4$s);%4$s::run_app()\"",
      port,
      host,
      set_golem.app.prod,
      get_golem_name(
        golem_wd = golem_wd
      )
    )
  }
  base_dock$CMD(
    dockerfile_cmd
  )
  base_dock
  base_dock$write(as = file.path(output_dir, "Dockerfile"),
                  append = single_file)


  if (!single_file){
  out <- sprintf(
"# use cd to move to the folder containing the Dockerfile
docker build -f Dockerfile_base --progress=plain -t %s .
docker build -f Dockerfile --progress=plain -t %s .
docker run -p %s:%s %s
# then go to 127.0.0.1:%s",
    tolower(
      paste0(
        get_golem_name(
          golem_wd = golem_wd
        ),
        "_base"
      )
    ),
    tolower(paste0(
      get_golem_name(
        golem_wd = golem_wd
      ),
      ":latest"
    )),
    port,
    port,
    tolower(paste0(
      get_golem_name(
        golem_wd = golem_wd
      ),
      ":latest"
    )),
    port
  )} else {




    out <- sprintf(
"# use cd to moove to the folder containing the Dockerfile
docker build -f Dockerfile --progress=plain -t %s .
docker run -p %s:%s %s
# then go to 127.0.0.1:%s",
			tolower(paste0(
				get_golem_name(
					golem_wd = golem_wd
				),
				":latest"
			)),
			port,
			port,
			tolower(paste0(
				get_golem_name(
					golem_wd = golem_wd
				),
				":latest"
			)),
			port
		)
	}

	cat(out, file = file.path(output_dir, "README"))

	open_or_go_to(
		where = file.path(output_dir, "README"),
		open_file = open
	)
}

#' @inheritParams add_dockerfile_with_renv
#' @rdname dockerfiles
#' @export
#' @export
add_dockerfile_with_renv_shinyproxy <- function(
  golem_wd = get_golem_wd(),
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  from = "rocker/verse",
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  open = TRUE,
  document = TRUE,
  update_tar_gz = TRUE,
  user = "rstudio",
  single_file = TRUE,
  set_golem.app.prod = TRUE,
  ...,
  source_folder
) {
  signal_arg_is_deprecated(
    source_folder,
    fun = as.character(sys.call()[[1]]),
    "source_folder"
  )

  add_dockerfile_with_renv(
    golem_wd = golem_wd,
    lockfile = lockfile,
    output_dir = output_dir,
    distro = distro,
    from = from,
    as = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    port = 3838,
    host = "0.0.0.0",
    extra_sysreqs = extra_sysreqs,
    update_tar_gz = update_tar_gz,
    open = open,
    document = document,
    user = user,
    single_file = single_file,
    set_golem.app.prod = set_golem.app.prod,
    dockerfile_cmd = sprintf(
      "R -e \"options('shiny.port'=3838,shiny.host='0.0.0.0');library(%1$s);%1$s::run_app()\"",
      get_golem_name(
        golem_wd = golem_wd
      )
    ),
    ...
  )
}

#' @inheritParams add_dockerfile_with_renv
#' @rdname dockerfiles
#' @export
#' @export
add_dockerfile_with_renv_heroku <- function(
  golem_wd = get_golem_wd(),
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  from = "rocker/verse",
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  open = TRUE,
  document = TRUE,
  user = "rstudio",
  update_tar_gz = TRUE,
  single_file = TRUE,
  set_golem.app.prod = TRUE,
  ...,
  source_folder
) {
	signal_arg_is_deprecated(
		source_folder,
		fun = as.character(sys.call()[[1]]),
		"source_folder"
	)

	add_dockerfile_with_renv(
		golem_wd = golem_wd,
		lockfile = lockfile,
		output_dir = output_dir,
		distro = distro,
		from = from,
		as = as,
		sysreqs = sysreqs,
		repos = repos,
		expand = expand,
		port = NULL,
		host = "0.0.0.0",
		extra_sysreqs = extra_sysreqs,
		update_tar_gz = update_tar_gz,
		open = FALSE,
		document = document,
		user = user,
		single_file = single_file,
		set_golem.app.prod = set_golem.app.prod,
		dockerfile_cmd = sprintf(
			"R -e \"options('shiny.port'=$PORT,shiny.host='0.0.0.0');library(%1$s);%1$s::run_app()\"",
			get_golem_name(
				golem_wd = golem_wd
			)
		),
		...
	)

	apps_h <- gsub(
		"\\.",
		"-",
		sprintf(
			"%s-%s",
			get_golem_name(
				golem_wd = golem_wd
			),
			get_golem_version(
				golem_wd = golem_wd
			)
		)
	)

	readme_output <- fs_path(
		output_dir,
		"README"
	)

	write_there <- write_there_builder(readme_output)

	write_there("From your command line, run:\n")

	write_there(
		sprintf(
			"docker build -f Dockerfile_base --progress=plain -t %s .",
			paste0(
				get_golem_name(
					golem_wd = golem_wd
				),
				"_base"
			)
		)
	)

	write_there(
		sprintf(
			"docker build -f Dockerfile --progress=plain -t %s .\n",
			paste0(
				get_golem_name(
					golem_wd = golem_wd
				),
				":latest"
			)
		)
	)

	write_there("Then, to push on heroku:\n")

	write_there("heroku container:login")
	write_there(
		sprintf("heroku create %s", apps_h)
	)
	write_there(
		sprintf("heroku container:push web --app %s", apps_h)
	)
	write_there(
		sprintf("heroku container:release web --app %s", apps_h)
	)
	write_there(
		sprintf("heroku open --app %s\n", apps_h)
	)
	write_there("> Be sure to have the heroku CLI installed.")

	write_there(
		sprintf("> You can replace %s with another app name.", apps_h)
	)

	# The open is deported here just to be sure
	# That we open the README once it has been populated
	open_or_go_to(
		where = readme_output,
		open_file = open
	)
}
