# This file contains all the necessary functions
# required to manipualte the golem-config file.

add_expr_tag <- function(tag) {
  attr(tag[[1]], "tag") <- "!expr"
  tag
}

# find and tag expressions in a yaml
# used internally in `amend_golem_config`
# This is an utilitary function to prevent
# the !expr from being lost in translation
# when manipulating the yaml
#
#' @importFrom utils modifyList
find_and_tag_exprs <- function(conf_path) {
  conf <- yaml::read_yaml(
    conf_path,
    eval.expr = FALSE
  )
  conf.eval <- yaml::read_yaml(
    conf_path,
    eval.expr = TRUE
  )

  expr_list <- lapply(
    names(conf),
    function(x) {
      conf[[x]][!conf[[x]] %in% conf.eval[[x]]]
    }
  )

  names(expr_list) <- names(conf)

  expr_list <- Filter(
    function(x) length(x) > 0,
    expr_list
  )

  tagged_exprs <- lapply(
    expr_list,
    add_expr_tag
  )

  modifyList(
    conf,
    tagged_exprs
  )
}



#' Amend golem config file
#'
#' @param key key of the value to add in `config`
#' @inheritParams config::get
#' @inheritParams add_module
#' @inheritParams set_golem_options
#'
#' @export
#' @importFrom yaml read_yaml write_yaml
#' @importFrom attempt stop_if
#'
#' @return Used for side effects.
amend_golem_config <- function(
  key,
  value,
  config = "default",
  pkg = golem::pkg_path(),
  talkative = TRUE
) {
  conf_path <- get_current_config(pkg)

  stop_if(
    conf_path,
    is.null,
    "Unable to retrieve golem config file."
  )

  cat_if_talk <- function(
  ...,
  fun = cat_green_tick
  ) {
    if (talkative) {
      fun(...)
    }
  }

  cat_if_talk(
    sprintf(
      "Setting `%s` to %s",
      key,
      value
    )
  )

  if (key == "golem_wd") {
    cat_if_talk(
      "You can change golem working directory with set_golem_wd('path/to/wd')",
      fun = cli_cat_line
    )
  }

  conf <- find_and_tag_exprs(conf_path)
  conf[[config]][[key]] <- value

  write_yaml(
    conf,
    conf_path
  )

  invisible(TRUE)
}
