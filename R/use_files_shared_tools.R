build_name <- function(
  name = NULL,
  url
) {
  if (is.null(name)) {
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

check_file_exists <- function(where) {
  if (fs_file_exists(where)) {
    cli_cli_abort(
      sprintf(
        "%s already exists.\n\nYou can delete it with:\nunlink('%s', recursive = TRUE).",
        where,
        where
      )
    )
  }
}
