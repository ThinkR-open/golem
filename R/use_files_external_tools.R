check_url_has_the_correct_extension <- function(
  url,
  type = c("js", "css", "html")
) {
  type <- match.arg(type)
  if (file_ext(url) != type) {
    cli_cli_abort(
      paste0(
        "File not added (URL must end with .",
        type,
        " extension)"
      )
    )
  }
}


download_external <- function(
  url,
  where_to_download
) {
  cat_start_download()
  utils_download_file(
    url,
    where_to_download
  )
  cat_downloaded(where_to_download)
}

perform_checks_and_download_if_everything_is_ok <- function(
  url_to_download_from,
  directory_to_download_to,
  where_to_download_to,
  file_type
) {
  if (!is.null(file_type)) {
    check_url_has_the_correct_extension(
      url = url_to_download_from,
      file_type
    )
  }
  check_directory_exists(directory_to_download_to)
  check_file_exists(where_to_download_to)
  download_external(url, where_to_download = where_to_download_to)
}