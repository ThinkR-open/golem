copy_internal_file <- function(
  path,
  where
){
  cat_start_copy()

  fs_file_copy(path, where)

  cat_copied(where)
}