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

check_directory_exists <- function(dir){
  if (!fs_dir_exists(dir)) {
    cli_cli_abort(
      sprintf(
        "The %s directory is required but does not exist.\n\nYou can create it with:\ndir.create('%s', recursive = TRUE)",
        dir,
        dir
      )
    )
  }
}
