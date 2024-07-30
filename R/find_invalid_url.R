#' @noRd
extract_urls_from_file <- function(file) {
  content <- readLines(file, warn = FALSE)
  url_pattern <- "(http|https)://[a-zA-Z0-9./?=_-]*"
  urls <- unique(unlist(regmatches(content, gregexpr(url_pattern, content))))
  names(urls) <- rep(file, length(urls))
  return(urls)
}

#' @noRd
check_url <- function(url) {
  response <- try(httr::GET(url), silent = TRUE)
  if (inherits(response, "try-error")) {
    res <- FALSE
  }

  res <- httr::status_code(response) == 200
  res <- stats::setNames(res, url)

  return(res)
}

#' Check for the validity of the URLs in the R folder
#'
#' @param exclude a character vector of urls to exclude
#'
#' @return a message if some URLs are invalid
#' @export
check_url_validity <- function(exclude = NA_character_) {
  if (!curl::has_internet()) {
    cli::cli_alert_info("No internet connection.")
    return(invisible(FALSE))
  }

  if (!dir.exists("R")) {
    cli::cli_alert_info("No R folder found.")
    return(invisible(FALSE))
  }

  urls <- purrr::map(
    files,
    ~ extract_urls_from_file(file = .x)
  ) |>
    unlist() |>
    purrr::discard(
      ~ .x %in% exclude
    ) |>
    purrr::map(
      check_url
    )

  invalid_urls <- urls |>
    purrr::keep(
      ~ .x == FALSE
    )

  if (length(invalid_urls) > 0) {
    cli::cli_alert_info("Some URLs are invalid.")
    purrr::walk(
      invalid_urls,
      ~ cli::cli_alert_danger(sprintf("URL %s is invalid in file {.file %s}", names(.x), names(invalid_urls)))
    )
  } else {
    cli::cli_alert_success("All URLs are valid.")
  }
}
