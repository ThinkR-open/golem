build_name <- function(
  name,
  url
) {
  if (missing(name) || is.null(name)) {
    name <- basename(url)
  }
  check_name_length_is_one(name)
  file_path_sans_ext(name)
}