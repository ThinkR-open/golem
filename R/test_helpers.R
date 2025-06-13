#' Test helpers
#'
#' These functions are designed to be used inside the tests
#' in your Shiny app package.
#'
#' @param object the object to test
#'
#' @return A testthat result.
#' @export
#' @rdname testhelpers
expect_shinytag <- function(
	object
) {
	rlang::check_installed(
		"testthat",
		"to run the tests."
	)
	act <- testthat::quasi_label(
		rlang::enquo(
			object
		),
		arg = "object"
	)
	act$class <- class(
		object
	)
	testthat::expect(
		"shiny.tag" %in% act$class,
		sprintf(
			"%s has class %s, not class 'shiny.tag'.",
			act$lab,
			paste(
				act$class,
				collapse = ", "
			)
		)
	)
	invisible(
		act$val
	)
}

#' @export
#' @rdname testhelpers
expect_shinytaglist <- function(
	object
) {
	rlang::check_installed(
		"testthat",
		"to run the tests.",
		version = "3.0.0"
	)
	act <- testthat::quasi_label(
		rlang::enquo(
			object
		),
		arg = "object"
	)
	act$class <- class(
		object
	)
	testthat::expect(
		"shiny.tag.list" %in% act$class,
		sprintf(
			"%s has class '%s', not class 'shiny.tag.list'.",
			act$lab,
			paste(
				act$class,
				collapse = ", "
			)
		)
	)
	invisible(
		act$val
	)
}

#' @export
#' @rdname testhelpers
#' @param ui output of an UI function
#' @param html deprecated
#' @param ... arguments passed  to `testthat::expect_snapshot()`
#' @importFrom attempt stop_if_not
expect_html_equal <- function(
	ui,
	html,
	...
) {
	rlang::check_installed(
		"testthat",
		"to run the tests.",
		version = "3.0.0"
	)

	if (
		!missing(
			html
		)
	) {
		message(
			"`html` is no longer used inside `expect_html_equal()`"
		)
	}

	testthat_expect_snapshot(
		x = ui,
		...
	)
}

#' @export
#' @rdname testhelpers
#' @param sleep number of seconds
#' @param R_path path to R. If NULL, the function will try to guess where R is.
expect_running <- function(
	sleep,
	R_path = NULL
) {
	rlang::check_installed(
		"testthat",
		"to run the tests.",
		version = "3.0.0"
	)
	testthat::skip_if_not_installed(
		"pkgload"
	)
	testthat::skip_if_not_installed(
		"processx"
	)
	testthat::skip_on_cran()

	# Ok for now we'll get back to this
	testthat::skip_if_not(
		rlang_is_interactive()
	)

	# Oh boy using testthat and processx is a mess
	#
	# We want to launch the app in a background process,
	# but we don't have access to the same stuff depending on
	# where we call the tests
	#
	# + We can launch with pkgload::load_all(), but __only__ if the
	#   current wd is the same as the golem wd
	# + We can launch with library(lib = ) but __only__ if we are in the
	#   non interactive testthat environment, __where the current package
	#   has been installed in a temporary library__
	#
	# There are six ways to call tests:
	#
	# - (1) Running the test interactively (i.e cmd A + cmd Enter):
	#   + We're in interactive mode
	#   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG")
	#   + The libPath is the default one
	#   + the wd is the golem path
	#   + We can use pkgload::load_all()
	#
	# - (2) Running the test inside the console, with devtools::test()
	#   + We're in interactive mode
	#   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
	#   + The libPath is the default one
	#   + the wd is the golem path
	#   + We can use pkgload::load_all()
	#
	# - (3) Running the test inside the console, with devtools::check()
	#   + We're not interactive mode
	#   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
	#   + the wd is a temp dir
	#   + The libPath is a temp one
	#   + We can't use pkgload
	#   + We can library()
	#
	# - (4) Clicking on the "Run Tests" button on test file File
	#   + We're not in interactive mode
	#   + We're not in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
	#   + the wd is the golem path
	#   + We can use pkgload
	#
	# - (5) Clicking on the "Test" button in RStudio Build Pane
	#   + We're not in interactive mode
	#   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG" )
	#   + the wd is the golem path
	#   + We can use pkgload
	#   This one is actually the tricky one: we need to detect that we
	#   are in testthat but non interactively, and inside the golem wd.
	#
	# - (6) Clicking on the "Check" button in RStudio Build Pane
	#   + We're not interactive mode
	#   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
	#   + the wd is a temp dir
	#   + The libPath is a temp one
	#   + We can't use pkgload
	#   + We can library()
	#
	#   So two sum up, two times where we can do library(): is when
	#   we're not in an child process launched

	if (Sys.getenv("CALLR_CHILD_R_LIBS_USER") == "") {
		pkg_name <- pkgload::pkg_name()
		# We are not in RCMDCHECK
		go_for_pkgload <- TRUE
	} else {
		pkg_name <- Sys.getenv(
			"TESTTHAT_PKG"
		)
		go_for_pkgload <- FALSE
	}

	if (
		is.null(
			R_path
		)
	) {
		if (
			tolower(
				.Platform$OS.type
			) ==
				"windows"
		) {
			r_ <- normalizePath(
				file.path(
					Sys.getenv(
						"R_HOME"
					),
					"bin",
					"R.exe"
				)
			)
		} else {
			r_ <- normalizePath(
				file.path(
					Sys.getenv(
						"R_HOME"
					),
					"bin",
					"R"
				)
			)
		}
	} else {
		r_ <- R_path
	}

	if (go_for_pkgload) {
		# Using pkgload because we can
		shinyproc <- processx::process$new(
			command = r_,
			c(
				"-e",
				"pkgload::load_all(here::here());run_app()"
			)
		)
	} else {
		# Using the temps libPaths because we can
		shinyproc <- processx::process$new(
			echo_cmd = TRUE,
			command = r_,
			c(
				"-e",
				sprintf(
					"library(%s, lib = '%s');run_app()",
					pkg_name,
					.libPaths()
				)
			),
			stdout = "|",
			stderr = "|"
		)
	}

	Sys.sleep(
		sleep
	)
	testthat::expect_true(
		shinyproc$is_alive()
	)
	shinyproc$kill()
}
