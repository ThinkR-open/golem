# @param ... Arguments passed to the `cat` function.
# @param default Boolean default value to return in case there is no user
#      interaction.
#
#' @importFrom utils menu
yesno <- function(..., default = FALSE) {
  if (!interactive()) {
    return(default)
  }
  cat(paste0(..., collapse = ""))
  menu(c("Yes", "No")) == 1
}
