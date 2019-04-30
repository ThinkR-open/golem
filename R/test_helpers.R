#' Test helpers
#' 
#' These functions are designed to be used inside the tests 
#' in your Shiny app package.
#'
#' @param object the object to test
#'
#' @return A testthat result
#' @export
#' @rdname testhelpers
#' 
#' @importFrom testthat quasi_label expect
#' @importFrom rlang enquo
#'
#' @examples
#' expect_shinytag(1)
expect_shinytag <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    act$class == "shiny.tag",
    sprintf("%s has class %s, not class 'shiny.tag'.", act$lab, act$class)
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @importFrom testthat quasi_label expect
#' @importFrom rlang enquo
expect_shinytaglist <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    act$class == "shiny.tag.list",
    sprintf("%s has class %s, not class 'shiny.tag.list'.", act$lab, act$class)
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @importFrom htmltools save_html
#' @importFrom attempt stop_if_not
#' @importFrom testthat expect_equal quasi_label expect
#' @importFrom rlang enquo
expect_html_equal <- function(ui, html){
  stop_if_not(html, file.exists, "Unable to find html file")
  tmp <- tempfile(fileext = ".html")
  save_html(ui, tmp)
  expect_equal(
    readLines(tmp),
    readLines(html), 
    label = "ui",  
    expected.label = "html document" 
  )
}
