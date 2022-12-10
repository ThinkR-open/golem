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
  pkg = get_golem_wd(),
  with_test = FALSE
) {
  added <- use_utils(
    file_name = "golem_utils_ui.R",
    folder_name = "R",
    pkg = pkg
  )

  if (added) {
    cat_green_tick("Utils UI added")

    if (with_test) {
      if (!isTRUE(fs_dir_exists("tests"))) {
        usethis_use_testthat()
      }
      pth <- fs_path(
        pkg,
        "tests",
        "testthat",
        "test-golem_utils_ui.R"
      )
      if (
        file.exists(pth)
      ) {
        file_already_there_dance(
          where = pth,
          open_file = FALSE
        )
      } else {
        use_utils_test_ui()
      }
    }
  }
}

#' @export
#' @rdname utils_files
use_utils_test_ui <- function(pkg = get_golem_wd()) {
  added <- use_utils(
    file_name = "test-golem_utils_ui.R",
    folder_name = "tests/testthat",
    pkg = pkg
  )

  if (added) {
    cat_green_tick("Tests on utils_ui added")
  }
}

#' @export
#' @rdname utils_files
use_utils_server <- function(
  pkg = get_golem_wd(),
  with_test = FALSE
) {
  added <- use_utils(
    file_name = "golem_utils_server.R",
    folder_name = "R",
    pkg = pkg
  )
  if (added) {
    cat_green_tick("Utils server added")

    if (with_test) {
      if (!isTRUE(fs_dir_exists("tests"))) {
        usethis_use_testthat()
      }
      pth <- fs_path(
        pkg,
        "tests",
        "testthat",
        "test-golem_utils_server.R"
      )
      if (
        file.exists(pth)
      ) {
        file_already_there_dance(
          where = pth,
          open_file = FALSE
        )
      } else {
        use_utils_test_server()
      }
    }
  }
}

use_utils_test_ <- function(
  pkg = get_golem_wd(),
  type = c("ui", "server")
) {
  type <- match.arg(type)
  added <- use_utils(
    file_name = sprintf("test-golem_utils_%s.R", type),
    folder_name = "tests/testthat",
    pkg = pkg
  )

  if (added) {
    cat_green_tick("Tests on utils_server added")
  }
}

#' @export
#' @rdname utils_files
use_utils_test_ui <- function(pkg = get_golem_wd()) {
  use_utils_test_(pkg, "ui")
}
#' @export
#' @rdname utils_files
use_utils_test_server <- function(pkg = get_golem_wd()) {
  use_utils_test_(pkg, "server")
}

use_utils <- function(
  file_name,
  folder_name,
  pkg = get_golem_wd()
) {
  old <- setwd(
    fs_path_abs(pkg)
  )
  on.exit(setwd(old))

  where <- fs_path(
    fs_path_abs(pkg),
    folder_name,
    file_name
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(FALSE)
  } else {
    fs_file_copy(
      path = golem_sys("utils", file_name),
      new_path = where
    )
    cat_created(where)
    return(TRUE)
  }
}
