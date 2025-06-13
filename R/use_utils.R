#' Use the utils files
#'
#' \describe{
#'   \item{use_utils_ui}{Copies the golem_utils_ui.R to the R folder.}
#'   \item{use_utils_server}{Copies the golem_utils_server.R to the R folder.}
#' }
#'
#' @inheritParams add_module
#'
#' @export
#' @rdname utils_files
#'
#' @importFrom utils capture.output
#'
#' @return Used for side-effects.
use_utils_ui <- function(
	golem_wd = get_golem_wd(),
	with_test = FALSE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	added <- use_utils(
		file_name = "golem_utils_ui.R",
		folder_name = "R",
		golem_wd = golem_wd
	)

	if (added) {
		cat_green_tick(
			"Utils UI added"
		)

		if (with_test) {
			if (
				!isTRUE(
					fs_dir_exists(
						"tests"
					)
				)
			) {
				usethis_use_testthat()
			}
			pth <- fs_path(
				golem_wd,
				"tests",
				"testthat",
				"test-golem_utils_ui.R"
			)
			if (
				file.exists(
					pth
				)
			) {
				file_already_there_dance(
					where = pth,
					open_file = FALSE
				)
			} else {
				use_utils_test_ui(
					golem_wd = golem_wd
				)
			}
		}
	}
}

#' @export
#' @rdname utils_files
use_utils_test_ui <- function(
	golem_wd = get_golem_wd(),
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	added <- use_utils(
		file_name = "test-golem_utils_ui.R",
		folder_name = "tests/testthat",
		golem_wd = golem_wd
	)

	if (added) {
		cat_green_tick(
			"Tests on utils_ui added"
		)
	}
}

#' @export
#' @rdname utils_files
use_utils_server <- function(
	golem_wd = get_golem_wd(),
	with_test = FALSE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	added <- use_utils(
		file_name = "golem_utils_server.R",
		folder_name = "R",
		golem_wd = golem_wd
	)
	if (added) {
		cat_green_tick(
			"Utils server added"
		)

		if (with_test) {
			if (
				!isTRUE(
					fs_dir_exists(
						"tests"
					)
				)
			) {
				usethis_use_testthat()
			}
			pth <- fs_path(
				golem_wd,
				"tests",
				"testthat",
				"test-golem_utils_server.R"
			)
			if (
				file.exists(
					pth
				)
			) {
				file_already_there_dance(
					where = pth,
					open_file = FALSE
				)
			} else {
				use_utils_test_server(
					golem_wd = golem_wd
				)
			}
		}
	}
}

use_utils_test_ <- function(
	golem_wd = get_golem_wd(),
	type = c(
		"ui",
		"server"
	)
) {
	type <- match.arg(
		type
	)
	added <- use_utils(
		file_name = sprintf(
			"test-golem_utils_%s.R",
			type
		),
		folder_name = "tests/testthat",
		golem_wd = golem_wd
	)

	if (added) {
		cat_green_tick(
			"Tests on utils_server added"
		)
	}
}

#' @export
#' @rdname utils_files
use_utils_test_ui <- function(
	golem_wd = get_golem_wd(),
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	use_utils_test_(
		golem_wd,
		"ui"
	)
}
#' @export
#' @rdname utils_files
use_utils_test_server <- function(
	golem_wd = get_golem_wd(),
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	use_utils_test_(
		golem_wd,
		"server"
	)
}

use_utils <- function(
	file_name,
	folder_name,
	golem_wd = get_golem_wd()
) {
	old <- setwd(
		fs_path_abs(
			golem_wd
		)
	)
	on.exit(
		setwd(
			old
		)
	)

	destination <- fs_path(
		fs_path_abs(
			golem_wd
		),
		folder_name,
		file_name
	)

	if (
		fs_file_exists(
			destination
		)
	) {
		cat_exists(
			destination
		)
		return(
			FALSE
		)
	} else {
		fs_file_copy(
			path = golem_sys(
				"utils",
				file_name
			),
			new_path = destination
		)
		cat_created(
			destination
		)
		return(
			TRUE
		)
	}
}
