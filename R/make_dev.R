#' Warn if called while {golem} is in production mode
#'
#' Helper used by development-time scaffolding functions (`use_*`,
#' `add_*`, `set_golem_*`) to alert the user when they are accidentally
#' invoked from a running app (i.e. when `options('golem.app.prod')` is
#' `TRUE`).
#'
#' @return Used for its side-effect (prints a `cli` warning).
#' @noRd
warn_if_in_prod_mode <- function() {
	if (!isTRUE(getOption("golem.app.prod"))) {
		return(invisible(NULL))
	}
	fun_call <- sys.call(-1)
	fun_name <- if (length(fun_call)) {
		as.character(fun_call[[1L]])
	} else {
		"This function"
	}
	warning(
		sprintf(
			"`%s()` is a development function and should not be called when {golem} is in production mode (`options('golem.app.prod' = TRUE)`).",
			fun_name
		),
		call. = FALSE
	)
	invisible(NULL)
}

#' Make a function dependent to dev mode
#'
#' The function returned will be run only if `golem::app_dev()`
#'     returns TRUE.
#'
#' @param fun A function
#'
#' @export
#'
#' @return Used for side-effects
make_dev <- function(
	fun
) {
	function(
		...
	) {
		if (golem::app_dev()) {
			fun(
				...
			)
		}
	}
}

`%||%` <- function(
	x,
	y
) {
	if (
		is.null(
			x
		)
	) {
		y
	} else {
		x
	}
}

#' Is the app in dev mode or prod mode?
#'
#' @return `TRUE` or `FALSE` depending on the status of `getOption( "golem.app.prod")`
#' @export
#'
#' @rdname prod
app_prod <- function() {
	getOption(
		"golem.app.prod"
	) %||%
		FALSE
}

# Well, this one does the opposite
#' @rdname prod
#' @export
app_dev <- function() {
	!golem::app_prod()
}

#' Functions already made dev dependent
#'
#' This functions will be run only if `golem::app_dev()`
#'     returns TRUE.
#' @rdname made_dev
#' @inheritParams base::cat
#' @export
#' @return A modified function.
cat_dev <- make_dev(
	base::cat
)

#' @rdname made_dev
#' @export
#' @inheritParams base::print
print_dev <- make_dev(
	base::print
)

#' @rdname made_dev
#' @export
#' @inheritParams base::message
message_dev <- make_dev(
	base::message
)

#' @rdname made_dev
#' @export
#' @inheritParams base::warning
warning_dev <- make_dev(
	base::warning
)

#' @rdname made_dev
#' @export
#' @inheritParams base::browser
browser_dev <- make_dev(
	base::browser
)
