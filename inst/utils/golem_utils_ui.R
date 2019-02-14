#' Turn an R list into an HTML list
#'
#' @param list An R list
#'
#' @return an HTML list
#' @export
#'
#' @importFrom htmltools tags tagAppendAttributes tagList
#'
#' @rdname lists
#'
#' @examples
#' list_to_li(c("a","b"))

list_to_li <- function(list, class = NULL){
  if (is.null(class)){
    tagList(lapply(list, tags$li))
  } else {
    res <- lapply(list, tags$li)
    res <- lapply(res, function(x) tagAppendAttributes(x, class = class))
    tagList(res)
  }

}

#' @export
#' @rdname lists
#' @importFrom htmltools tags tagAppendAttributes tagList

list_to_p <- function(list, class = NULL){
  if (is.null(class)){
    tagList(lapply(list, tags$p))
  } else {
    res <- lapply(list, tags$p)
    res <- lapply(res, function(x) tagAppendAttributes(x, class = class))
    tagList(res)
  }

}

#' @export
#' @rdname lists
#' @importFrom glue glue
#' @importFrom htmltools tags tagAppendAttributes tagList


named_to_li <- function(list, class = NULL){
  if(is.null(class)){
    res <- mapply(
      function(x, y){
        tags$li(HTML(glue("<b>{y}:</b> {x}")))
      },
      list, names(list), SIMPLIFY = FALSE)
    #res <- lapply(res, HTML)
    tagList(res)
  } else {
    res <- mapply(
      function(x, y){
        tags$li(HTML(glue("<b>{y}:</b> {x}")))
      },
      list, names(list), SIMPLIFY = FALSE)
    res <- lapply(res, function(x) tagAppendAttributes(x, class = class))
    tagList(res)
  }
}

#' Remove a tag attribute
#'
#' @param tag the tag
#' @param ... the attributes to remove
#'
#' @return a new tag
#' @export
#'
#' @examples
#' a <- tags$p(src = "plop", "pouet")
#' tagRemoveAttributes(a, "src")

tagRemoveAttributes <- function(tag, ...) {
  attrs <- as.character(list(...))
  for (i in seq_along(attrs)) {
    tag$attribs[[ attrs[i] ]] <- NULL
  }
  tag
}

#' Hide or display a tag
#'
#' @param tag the tag
#'
#' @return a tag
#' @export
#
#' @importFrom htmltools tagList
#'
#' @examples
#' ## Hide
#' a <- shiny::tags$p(src = "plop", "pouet")
#' undisplay(a)
#' b <- shiny::actionButton("go_filter", "go")
#' undisplay(b)
#' @rdname display

undisplay <- function(tag) {
  # if not already hidden
  if (!is.null(tag$attribs$style) && !grepl("display:\\s+none", tag$attribs$style)) {
    tag$attribs$style <- paste("display: none;", tag$attribs$style)
  } else {
    tag$attribs$style <- "display: none;"
  }
  tag
}

#' @rdname display
#' @importFrom htmltools tagList
#'
#' @examples
#'
#' ## Show
#' a <- shiny::tags$p(src = "plop", "pouet")
#' a_hidden <- undisplay(a)
#' display(a_hidden)
#' # do not change not hidden tags
#' b_show <- shiny::actionButton("go_filter", "go")
#' display(b_show)
#' # Keep other attributes
#' b_show$attribs$style <- 'display: none; background: red'
#' display(b_show)
#'
#' @export

display <- function(tag) {
  if (!is.null(tag$attribs$style) && grepl("display:\\s+none", tag$attribs$style)) {
    tag$attribs$style <- gsub("(\\s)*display:(\\s)*none(\\s)*(;)*(\\s)*", "", tag$attribs$style)
  }
  tag
}

#' Add a red star at the end of the text
#'
#' Adds a red star at the end of the text
#' (for example for indicating mandatory fields).
#'
#' @param text the HTLM text to put before the red star
#'
#' @return an html element
#' @export
#'
#' @examples
#' with_red_star("Enter your name here")
#'
#' @importFrom htmltools tags HTML
#'
with_red_star <- function(text) {
  htmltools::tags$span(
    HTML(
      paste0(
        text,
        htmltools::tags$span(
          style = "color:red", "*"
        )
      )
    )
  )
}



#' Repeat tags$br
#'
#' @param times the number of br to return
#'
#' @return the number of br specified in times
#' @export
#'
#' @examples
#' rep_br(5)
#'
#' @importFrom htmltools HTML

rep_br <- function(times = 1) {
  HTML(rep("<br/>", times = times))
}

#' Create an url
#'
#' @param url the URL
#' @param text the text to display
#'
#' @return an a tag
#' @export
#'
#' @examples
#' enurl("https://www.thinkr.fr", "ThinkR")

enurl <- function(url, text){
  tags$a(href = url, text)
}


#' Columns 12, 6 and 4
#' 
#' Most shiny columns are 12, 6 or 4 of width. 
#' These are convenient wrappers around 
#' `column(12, ...)`, `column(6, ...)` and `column(4, ...)`.
#' 
#' @export
#' @rdname columns
col_12 <- function(...){
  shiny::column(12, ...)
}

#' @export
#' @rdname columns
col_6 <- function(...){
  shiny::column(6, ...)
}

#' @export
#' @rdname columns
col_4 <- function(...){
  shiny::column(4, ...)
}
