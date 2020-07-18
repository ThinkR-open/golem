#' @importFrom utils menu
yesno <- function (...) 
{
  cat(paste0(..., collapse = ""))
  menu(c("Yes", "No")) == 1
}
