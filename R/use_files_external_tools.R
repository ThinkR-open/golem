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
  url_to_download_from,
  where_to_download
) {
  cat_start_download()
  utils_download_file(
    url_to_download_from,
    where_to_download
  )
  cat_downloaded(where_to_download)
}

perform_checks_and_download_if_everything_is_ok <- function(
  url_to_download_from,
  directory_to_download_to,
  file_type,
  file_created_fun,
  pkg,
  name,
  open
) {
  name <- build_name(
    name,
    url
  )
  if (is.null(file_type)) {
    where_to_download_to <- fs_path(
      directory_to_download_to,
      name
    )
  } else {
    check_url_has_the_correct_extension(
      url = url_to_download_from,
      file_type
    )
    where_to_download_to <- fs_path(
      directory_to_download_to,
      sprintf(
        "%s.%s",
        name,
        file_type
      )
    )
  }
  check_directory_exists(
    directory_to_download_to
  )
  check_file_exists(
    where_to_download_to
  )
  download_external(
    url_to_download_from = url_to_download_from,
    where_to_download = where_to_download_to
  )
  file_created_dance(
    where = where_to_download_to,
    fun = file_created_fun,
    pkg = pkg,
    dir = directory_to_download_to,
    name = name,
    open = open,
    open_or_go_to = FALSE,
    catfun = cat_downloaded
  )
}