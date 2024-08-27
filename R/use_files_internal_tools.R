copy_internal_file <- function(
  path,
  where
){
  cat_start_copy()

  fs_file_copy(path, where)

  cat_copied(where)
}

check_file_has_the_correct_extension <- function(
  path,
  type = c("js", "css", "html")
) {
  type <- match.arg(type)
  if (file_ext(path) != type) {
    cli_cli_abort(
      paste0(
        "File not added (URL must end with .",
        type,
        " extension)"
      )
    )
  }
}

check_if_file_exists_and_copy_if_not <- function(
  path,
  where_to_copy_to
) {
  check_file_exists(where_to_copy_to)
  copy_internal_file(path, where_to_copy_to)
}