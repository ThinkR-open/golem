#' @noRd
stop_quietly <- function() {
  opt <- options(show.error.messages = FALSE)
  on.exit(options(opt))
  stop()
}

#' @noRd
is_shiny_input_output_funmodule <- function(
  text,
  extend_input_output_funmodule = NA_character_
) {
  stopifnot(is.character(extend_input_output_funmodule))

  input_output_knew <- c("Input|Output|actionButton|radioButtons")
  ui_funmodule_pattern <- c("mod_\\w+_ui")

  patterns <- paste(
    input_output_knew,
    ui_funmodule_pattern,
    sep = "|"
  )

  if (
    !is.null(extend_input_output_funmodule) ||
      !is.na(extend_input_output_funmodule) ||
      extend_input_output_funmodule == ""
  ) {
    patterns <- paste(
      patterns,
      extend_input_output_funmodule,
      sep = "|"
    )
  }

  grepl(
    pattern = patterns,
    x = text
  )
}

#' @noRd
#' @importFrom utils getParseData
check_namespace_in_file <- function(
  path,
  extend_input_output_funmodule = NA_character_
) {
  getParseData(
    parse(
      file = path,
      keep.source = TRUE
    )
  ) |>
    dplyr::mutate(
      path = path
    ) |>
    dplyr::filter(
      token == "SYMBOL_FUNCTION_CALL"
    ) |>
    dplyr::mutate(
      is_input_output_funmodule = is_shiny_input_output_funmodule(
        text = text,
        extend_input_output_funmodule = extend_input_output_funmodule
      )
    ) |>
    dplyr::mutate(
      is_followed_by = dplyr::lead(text),
      is_followed_by_ns = is_followed_by == "ns"
    ) |>
    dplyr::filter(
      is_input_output_funmodule
    )
}

#' check namespace sanity
#' Will check if the namespace (NS) are correctly set in the shiny modules
#'
#' @param pkg The package path
#' @param extend_input_output_funmodule Extend the input, output or function module to check
#' @param disable Disable the check
#'
#' @importFrom roxygen2 parse_package block_get_tag
#'
#' @return Logical. TRUE if the namespace are correctly set, FALSE otherwise
#'
#' @export
check_namespace_sanity <- function(
  pkg = golem::get_golem_wd(),
  extend_input_output_funmodule = NA_character_,
  disable = FALSE
) {
  if (disable) {
    return(invisible(FALSE))
  }

  check_desc_installed()
  check_cli_installed()

  base_path <- normalizePath(
    path = pkg,
    mustWork = TRUE
  )

  encoding <- desc::desc_get("Encoding", file = base_path)[[1]]

  if (!identical(encoding, "UTF-8")) {
    warning("roxygen2 requires Encoding: UTF-8", call. = FALSE)
  }

  blocks <- roxygen2::parse_package(
    path = ".",
    env = NULL
  )

  shinymodule_blocks <- blocks |>
    purrr::map(
      .f = \(x) {
        return <- roxygen2::block_get_tag(x, tag = "shinyModule")
        if (is.null(return)) {
          NULL
        } else {
          return
        }
      }
    ) |>
    purrr::compact()

  if (length(shinymodule_blocks) == 0) {
    cli::cli_alert_info("No shiny module found")
    return(invisible(FALSE))
  }

  shinymodule_links <- shinymodule_blocks |>
    purrr::map_chr(
      .f = ~ .x[["file"]]
    ) |>
    unique()

  data <- shinymodule_links |>
    purrr::map_df(
      .f = ~ check_namespace_in_file(
        path = .x,
        extend_input_output_funmodule = extend_input_output_funmodule
      )
    ) |>
    dplyr::filter(
      !is_followed_by_ns
    ) |>
    dplyr::select(
      path,
      text,
      line1,
      col1,
      is_followed_by,
      is_followed_by_ns
    ) |>
    dplyr::mutate(
      message = sprintf("... see line %d in {.file %s:%d:%d}.", line1, path, line1, col1)
    )

  missing_ns_detected <- nrow(data)

  if (missing_ns_detected == 0) {
    cli::cli_alert_success("NS check passed")
    return(invisible(TRUE))
  }

  cli::cli_text(
    "It seems that ",
    cli::bg_br_yellow(
      "{missing_ns_detected} namespace{?s} (NS) {?is/are} missing..."
    )
  )

  cli::cli_alert_info("Fix {?this/these} {missing_ns_detected} missing namespace{?s} before to continue...")

  purrr::walk(data$message, cli::cli_alert_danger)

  launch_app <- yesno("Is it fixed? Do you want to launch the app?")

  if (isFALSE(launch_app)) {
    stop_quietly()
  }

  return(invisible(TRUE))
}
