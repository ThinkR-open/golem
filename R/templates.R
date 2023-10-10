#' Project Hook
#'
#' Project hooks allow to define a function run just after `{golem}`
#' project creation.
#'
#' @inheritParams create_golem
#' @param ... Arguments passed from `create_golem()`, unused in the default
#' function.
#'
#' @return Used for side effects
#' @export
#'
#' @examples
#' if (interactive()) {
#'   my_proj <- function(...) {
#'     unlink("dev/", TRUE, TRUE)
#'   }
#'   create_golem("ici", project_template = my_proj)
#' }
project_hook <- function(path, package_name, ...) {
  return(TRUE)
}

#' Golem's default custom templates
#'
#' These functions do not aim at being called as is by
#' users, but to be passed as an argument to the `add_js_handler()`
#' function.
#'
#' @param path The path to the JS script where this template will be written.
#' @param name Shiny's custom handler name.
#' @param code JavaScript code to be written in the function.
#' @return Used for side effect
#' @rdname template
#' @export
#' @seealso [add_js_handler()]
js_handler_template <- function(
  path,
  name = "fun",
  code = " "
) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  write_there("$( document ).ready(function() {")
  write_there(
    sprintf("  Shiny.addCustomMessageHandler('%s', function(arg) {", name)
  )
  write_there(code)
  write_there("  })")
  write_there("});")
}

#' @export
#' @rdname template
js_template <- function(
  path,
  code = " "
) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  write_there(code)
}

#' @export
#' @rdname template
css_template <- function(
  path,
  code = " "
) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  write_there(code)
}

#' @export
#' @rdname template
sass_template <- function(
  path,
  code = " "
) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  write_there(code)
}

#' @export
#' @rdname template
empty_template <- function(
  path,
  code = " "
    ) {
  write_there <- function(...) {
    write(..., file = path, append = TRUE)
  }

  write_there(code)
}
