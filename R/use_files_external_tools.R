download_external <- function(
  url,
  where
) {
  cat_start_download()
  utils_download_file(url, where)
  cat_downloaded(where)
}