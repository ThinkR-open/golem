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
#' expect_shinytag(shiny::tags$span("1"))
expect_shinytag <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    "shiny.tag" %in% act$class,
    sprintf("%s has class %s, not class 'shiny.tag'.", act$lab, paste(act$class, collapse = ", "))
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @importFrom testthat quasi_label expect
#' @importFrom rlang enquo
#' @examples
#' expect_shinytaglist(shiny::tagList(1))
expect_shinytaglist <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    "shiny.tag.list" %in% act$class,
    sprintf("%s has class '%s', not class 'shiny.tag.list'.", act$lab, paste(act$class, collapse = ", "))
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @param ui output of an UI function
#' @param html html file to compare to ui 
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
