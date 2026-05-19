#' Create a Dockerfile for your App
#'
#' Build a container containing your Shiny App.
#' `add_dockerfile_with_renv()` creates a generic Dockerfile based on
#' `{renv}`, while `add_dockerfile_with_renv_shinyproxy()` and
#' `add_dockerfile_with_renv_heroku()` create platform-specific
#' Dockerfiles.
#'
#' @param path path to the DESCRIPTION file to use as an input.
#' @param from The FROM of the Dockerfile. Default is
#'
#'     FROM rocker/verse
#'
#'     without renv.lock file passed
#'     `R.Version()$major`.`R.Version()$minor` is used as tag
#'
#' @param as The AS of the Dockerfile. Default it NULL.
#' @param port The `options('shiny.port')` on which to run the App.
#'     Default is 80.
#' @param host The `options('shiny.host')` on which to run the App.
#'    Default is 0.0.0.0.
#' @param sysreqs boolean. If TRUE, RUN statements to install packages
#' system requirements will be included in the Dockerfile.
#' @param repos character. The URL(s) of the repositories to use for `options("repos")`.
#' @param expand boolean. If `TRUE` each system requirement will have its own `RUN` line.
#' @param open boolean. Should the Dockerfile/README/README be open after creation? Default is `TRUE`.
#' @param update_tar_gz boolean. If `TRUE` an updated tar.gz is created.
#' @param extra_sysreqs character vector. Extra debian system requirements.
#'
#' @note `add_dockerfile()`, `add_dockerfile_shinyproxy()`, and
#' `add_dockerfile_heroku()` are now hard deprecated and will error when
#' called; use the corresponding `add_dockerfile_with_renv_*()` functions
#' instead.
#'
#' @export
#' @rdname dockerfiles
#'
#'
#' @examples
#' \donttest{
#' # Create a 'deploy' folder containing everything needed to deploy
#' # the golem using docker based on {renv}
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile_with_renv(
#'     # lockfile = "renv.lock", # uncomment to use existing renv.lock file
#'     output_dir = "deploy"
#'   )
#' }
#' }
#' @return The `{dockerfiler}` object, invisibly.
add_dockerfile <- function(
	...
) {
	warn_if_in_prod_mode()
	.Defunct(
		new = "add_dockerfile_with_renv",
		msg = "add_dockerfile() is defunct. Please use add_dockerfile_with_renv() instead."
	)
}

#' @export
#' @rdname dockerfiles
add_dockerfile_shinyproxy <- function(
	...
) {
	warn_if_in_prod_mode()
	.Defunct(
		new = "add_dockerfile_with_renv_shinyproxy",
		msg = "add_dockerfile_shinyproxy() is defunct. Please use add_dockerfile_with_renv_shinyproxy() instead."
	)
}

#' @export
#' @rdname dockerfiles
add_dockerfile_heroku <- function(
	...
) {
	warn_if_in_prod_mode()
	.Defunct(
		new = "add_dockerfile_with_renv_heroku",
		msg = "add_dockerfile_heroku() is defunct. Please use add_dockerfile_with_renv_heroku() instead."
	)
}
