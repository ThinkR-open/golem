# For mocking purposes

curl_get_headers <- function(...) {
  curlGetHeaders(...)
}

utils_download_file <- function(...) {
  utils::download.file(...)
}