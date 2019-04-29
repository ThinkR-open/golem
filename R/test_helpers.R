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
#' @importFrom testthat quasi_label
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
expect_shinytaglist <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    act$class == "shiny.tag.list",
    sprintf("%s has class %s, not class 'shiny.tag.list'.", act$lab, act$class)
  )
  invisible(act$val)
}