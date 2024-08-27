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
  where
) {
  cat_start_download()
  utils_download_file(url, where)
  cat_downloaded(where)
}

check_if_file_exists_and_download_if_not <- function(
  url,
  where_to_download
){
  check_file_exists(where_to_download)
  download_external(url, where_to_download)
}