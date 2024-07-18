#' @importFrom roxygen2 roxy_tag_parse
#' @importFrom roxygen2 roxy_tag_rd
NULL

#' @importFrom roxygen2 tag_markdown
#' @export
roxy_tag_parse.roxy_tag_shinyModule <- function(x) {
  tag_markdown(
    x = x
  )
}

#' @importFrom roxygen2 rd_section
#' @export
roxy_tag_rd.roxy_tag_shinyModule <- function(x, base_path, env) {
  rd_section(
    type = "shinyModule",
    value = x$val
  )
}

#' @export
format.rd_section_shinyModule <- function(x, ...) {
  paste0(
    "\\section{Shiny module}{\n",
    x$value,
    "\n}"
  )
}

#' shinyModule tag
#' @importFrom roxygen2 roclet
#' @export
shinyModule_roclet <- function() {
  roclet("shinyModule")
}
