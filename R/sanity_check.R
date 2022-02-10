#' Sanity check for R files in the project
#'
#' This function is used check for any `browser()`` or commented
#' #TODO / #TOFIX / #BUG in the code
#'
#' @inheritParams add_module
#'
#' @rdname sanity_check
#' @export
#'
#' @importFrom rstudioapi sourceMarkers hasFun isAvailable
#'
#' @return A DataFrame if any of the words has been found.
sanity_check <- function(pkg = get_golem_wd()) {
  all_R_files <- list.files(
    path = pkg,
    pattern = "\\.R$",
    recursive = TRUE
  )

  to_find <- c("browser()", "#TODO", "#TOFIX", "#BUG", "# TODO", "# TOFIX", "# BUG")

  source_markers <- data.frame()

  for (file_name in all_R_files) {
    file <- readLines(file_name, warn = FALSE)

    for (word in to_find) {
      line_number <- grep(word, file, fixed = TRUE)
      if (length(line_number) > 0) {
        df <- data.frame(
          type = "warning",
          file = file_name,
          line = line_number,
          message = paste("Found", word, sep = " "),
          column = 1
        )
        source_markers <- rbind.data.frame(source_markers, df)
      }
    }
  }

  if (length(source_markers) > 0) {
    if (rstudioapi::isAvailable() & rstudioapi::hasFun("sourceMarkers")) {
      rstudioapi::sourceMarkers("sanity_check", markers = source_markers)
    }
    return(source_markers)
  } else {
    cat_green_tick("Sanity check passed successfully.")
  }
}
