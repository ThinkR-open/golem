
# All the fns here check that {usethis} is installed
# before doing anything.
check_usethis_installed <- function(reason = "for project and file manipulation.") {
	rlang::check_installed(
		"usethis",
		version = "1.6.0",
		reason = reason
	)
}

usethis_use_build_ignore <- function(
	files,
	escape = TRUE
) {
	check_usethis_installed(
		reason = "to ignore files in the build."
	)
	usethis::use_build_ignore(
		files,
		escape
	)
}
usethis_use_package <- function(
	package,
	type = "Imports",
	min_version = NULL
) {
	check_usethis_installed(
		reason = "to add dependencies to DESCRIPTION."
	)
	usethis::use_package(
		package,
		type,
		min_version
	)
}

usethis_create_project <- function(
	path,
	rstudio = rstudioapi::isAvailable(),
	open = rlang::is_interactive()
) {
	check_usethis_installed(
		reason = "to create a project."
	)
	usethis::create_project(
		path,
		rstudio,
		open
	)
}
usethis_use_latest_dependencies <- function(
	overwrite = FALSE,
	source = c("local", "CRAN")
) {
	check_usethis_installed(
		reason = "to set dependency version."
	)
	usethis::use_latest_dependencies(
		overwrite,
		source
	)
}

usethis_proj_set <- function(
	path = ".",
	force = FALSE
) {
	check_usethis_installed(
		reason = "to set project."
	)
	usethis::proj_set(
		path,
		force
	)
}
usethis_use_testthat <- function(
	edition = NULL,
	parallel = FALSE
) {
	check_usethis_installed(
		reason = "to add {testthat} infrastructure."
	)
	usethis::use_testthat(
		edition,
		parallel
	)
}
usethis_use_test <- function(
	name = NULL,
	open = rlang::is_interactive()
) {
	check_usethis_installed(
		reason = "to add tests."
	)
	usethis::use_test(
		name,
		open
	)
}

usethis_use_spell_check <- function(
	vignettes = TRUE,
	lang = "en-US",
	error = FALSE
) {
	check_usethis_installed(
		reason = "to add spellcheck."
	)
	usethis::use_spell_check(
		vignettes,
		lang,
		error
	)
}
