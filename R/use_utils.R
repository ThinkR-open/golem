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
#' @importFrom cli cat_bullet
#' @importFrom utils capture.output
#' @importFrom usethis use_testthat
#'
#' @return Used for side-effects.
use_utils_ui <- function(pkg = get_golem_wd(),
                         with_test = FALSE) {
  added <- use_utils(
    file_name = "golem_utils_ui.R",
    folder_name = "R",
    pkg = pkg
  )

  if (added) {
    cat_green_tick("Utils UI added")

    if (with_test) {
      if (!isTRUE(dir.exists("tests"))) {
        use_testthat()
      }
      pth <- path(
        pkg, "tests", "testthat", "test-golem_utils_ui.R"
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
use_utils_server <- function(pkg = get_golem_wd(),
                             with_test = FALSE) {
  added <- use_utils(
    file_name = "golem_utils_server.R",
    folder_name = "R",
    pkg = pkg
  )
  if (added) {
    cat_green_tick("Utils server added")

    if (with_test) {
      if (!isTRUE(dir.exists("tests"))) {
        use_testthat()
      }
      pth <- path(
        pkg, "tests", "testthat", "test-golem_utils_server.R"
      )
      if (
        file.exists(pth)
      ) {
        file_already_there_dance(
          where = pth,
          open_file = FALSE
        )
      } else {
        # use_utils_test_server()
      }
    }
  }
}

#' @export
#' @rdname utils_files
use_utils_test_ui <- function(pkg = get_golem_wd()) {
  added <- use_utils(
    file_name = "test-golem_utils_server.R",
    folder_name = "tests/testthat",
    pkg = pkg
  )

  if (added) {
    cat_green_tick("Tests on utils_server added")
  }
}

#' @importFrom fs file_copy path_abs path_file
use_utils <- function(file_name,
                      folder_name,
                      pkg = get_golem_wd()) {
  old <- setwd(
    path_abs(pkg)
  )
  on.exit(setwd(old))
  where <- path(path_abs(pkg), folder_name, file_name)
  if (file_exists(where)) {
    cat_exists(where)
    return(FALSE)
  } else {
    file_copy(
      path = golem_sys("utils", file_name),
      new_path = where
    )
    cat_created(where)
    return(TRUE)
  }
}