#' Detach all attached package
#'
#' @importFrom attempt attempt
#' @importFrom utils sessionInfo
#'
#' @export
#'
#' @return TRUE, invisibly.
detach_all_attached <- function() {
	all_attached <- paste(
		"package:",
		names(
			sessionInfo()$otherPkgs
		),
		sep = ""
	)

	attempt(
		suppressWarnings(
			invisible(
				lapply(
					all_attached,
					detach,
					character.only = TRUE,
					unload = TRUE
				)
			)
		),
		silent = TRUE
	)
	return(
		invisible(
			TRUE
		)
	)
}

check_name_consistency <- function(
	golem_wd
) {
	old_dir <- setwd(
		golem_wd
	)

	package_name_from_desc <- desc_get(
		keys = "Package"
	)
	package_name_from_config <- c()

	pth <- fs_path(
		golem_wd,
		"R",
		"app_config.R"
	)
	app_config <- parse(
		file = pth
	)

	handler_CodeWalker <- function(
		e,
		w
	) {
		return(
			NULL
		)
	}

	call_CodeWalker <- function(
		expr,
		w
	) {
		fn <- expr[[1]]
		if (
			is.symbol(
				fn
			) &&
				as.character(
					fn
				) ==
					"system.file"
		) {
			args <- as.list(
				expr
			)[-1]
			package_name_from_config <<- c(
				package_name_from_config,
				args$package
			)
		}
		for (e in as.list(
			expr
		)[-1L]) {
			codetools::walkCode(
				e,
				w
			)
		}
	}

	leaf_CodeWalker <- function(
		e,
		w
	) {
		return(NULL)
	}

	lapply(
		app_config,
		function(expr) {
			codetools::walkCode(
				expr,
				codetools::makeCodeWalker(
					handler = handler_CodeWalker,
					call = call_CodeWalker,
					leaf = leaf_CodeWalker
				)
			)
		}
	)

	setwd(
		old_dir
	)

	if (
		length(
			unique(
				c(
					package_name_from_config,
					package_name_from_desc
				)
			)
		) ==
			1
	) {
		return(
			invisible(
				TRUE
			)
		)
	} else {
		stop(
			call. = FALSE,
			"Package name does not match in DESCRIPTION and `app_sys()`.\n",
			"\n",
			sprintf(
				"In DESCRIPTION: '%s'\n",
				package_name_from_desc
			),
			sprintf(
				"R/app_config.R : '%s'\n",
				paste(
					package_name_from_config,
					collapse = ", "
				)
			),
			"\n",
			sprintf(
				"Please make both these names match before continuing, for example using golem::set_golem_name('%s')",
				package_name_from_desc
			)
		)
	}
}

#' Document and reload your package
#'
#' This function calls \code{rstudioapi::documentSaveAll()},
#' \code{roxygen2::roxygenise()} and \code{pkgload::load_all()}.
#'
#' @inheritParams add_module
#' @inheritParams roxygen2::roxygenise
#' @inheritParams pkgload::load_all
#'
#' @param ... Other arguments passed to `pkgload::load_all()`
#' @export
#'
#' @return Used for side-effects
document_and_reload <- function(
	golem_wd = get_golem_wd(),
	roclets = NULL,
	load_code = NULL,
	clean = FALSE,
	export_all = FALSE,
	helpers = FALSE,
	attach_testthat = FALSE,
	...,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	# We'll start by checking if the package name is correct

	check_name_consistency(
		golem_wd
	)
	rlang::check_installed(
		"pkgload"
	)

	if (
		rlang::is_installed(
			"rstudioapi"
		) &&
			rstudioapi::isAvailable() &&
			rstudioapi::hasFun(
				"documentSaveAll"
			)
	) {
		rstudioapi::documentSaveAll()
	}
	roxed <- try({
		roxygen2_roxygenise(
			package.dir = golem_wd,
			roclets = roclets,
			load_code = load_code,
			clean = clean
		)
	})
	if (
		attempt::is_try_error(
			roxed
		)
	) {
		cli_cat_rule(
			"Error documenting your package"
		)
		dialog_if_has(
			"Alert",
			"Error documenting your package"
		)
		return(
			invisible(
				FALSE
			)
		)
	}
	loaded <- try({
		pkgload_load_all(
			golem_wd,
			export_all = export_all,
			helpers = helpers,
			attach_testthat = attach_testthat,
			quiet = TRUE,
			...
		)
	})

	if (
		attempt::is_try_error(
			loaded
		)
	) {
		cli_cat_rule(
			"Error loading your package"
		)
		dialog_if_has(
			"Alert",
			"Error loading your package"
		)
		return(
			invisible(
				FALSE
			)
		)
	}
}

dialog_if_has <- function(
	title,
	message,
	url = ""
) {
	if (
		rlang::is_installed(
			"rstudioapi"
		) &&
			rstudioapi::isAvailable() &&
			rstudioapi::hasFun(
				"showDialog"
			)
	) {
		rstudioapi::showDialog(
			title,
			message,
			url
		)
	}
}
