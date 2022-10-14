# All the fns here check that {dockerfiler} is installed
# before doing anything.
check_dockerfiler_installed <- function() {
	rlang::check_installed(
		"dockerfiler",
		version = "0.2.0",
		reason = "to build a Dockerfile."
	)
}

dockerfiler_dock_from_renv <- function(
	lockfile = "renv.lock",
	distro = "focal",
	FROM = "rocker/r-base",
	AS = NULL,
	sysreqs = TRUE,
	repos = c(CRAN = "https://cran.rstudio.com/"),
	expand = FALSE,
	extra_sysreqs = NULL
) {
	check_dockerfiler_installed()
	dockerfiler::dock_from_renv(
		lockfile = lockfile,
		distro = distro,
		FROM = FROM,
		AS = AS,
		sysreqs = sysreqs,
		repos = repos,
		expand = expand,
		extra_sysreqs = extra_sysreqs
	)
}

dockerfiler_dock_from_desc <- function(
	path = "DESCRIPTION",
	FROM = paste0(
		"rocker/r-ver:",
		R.Version()$major,
		".",
		R.Version()$minor
	),
	AS = NULL,
	sysreqs = TRUE,
	repos = c(CRAN = "https://cran.rstudio.com/"),
	expand = FALSE,
	update_tar_gz = TRUE,
	build_from_source = TRUE,
	extra_sysreqs = NULL
) {
	check_dockerfiler_installed()
	dockerfiler::dock_from_desc(
		path = path,
		FROM = FROM,
		AS = AS,
		sysreqs = sysreqs,
		repos = repos,
		expand = expand,
		update_tar_gz = update_tar_gz,
		build_from_source = build_from_source,
		extra_sysreqs = extra_sysreqs
	)
}


dockerfiler_Dockerfile <- function() {
	check_dockerfiler_installed()
	dockerfiler::Dockerfile
}
