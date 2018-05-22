#' Create a Rstudio Project dedicated to shinyapp
#'
#' @param path path to create
#' @param ... not used
#'
#' @export
create_shiny_template <- function(path, ...) {
dir.create(path, recursive = TRUE, showWarnings = FALSE)
devtools::create(path = path)
from <- system.file("shinytemplate","",package = "shinytemplate")
ll <- list.files(path = from, full.names = TRUE, all.files = TRUE)
file.copy(from = ll, to = path, overwrite = TRUE, recursive = TRUE)
}
