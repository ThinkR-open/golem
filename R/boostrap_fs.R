# All the fns here check that {fs} is installed
# before doing anything.
check_fs_installed <- function() {
  rlang::check_installed(
    "fs",
    reason = "for file & directory manipulation.\nYou can install all {golem} dev dependencies with `golem::install_dev_deps()`."
  )
}

fs_dir_exists <- function(path) {
  check_fs_installed()
  fs::dir_exists(path)
}

fs_dir_create <- function(
  path,
  ...,
  mode = "u=rwx,go=rx",
  recurse = TRUE,
  recursive
) {
  check_fs_installed()
  fs::dir_create(
    path,
    ...,
    mode = mode,
    recurse = recurse,
    recursive = recursive
  )
}

fs_file_create <- function(where) {
  check_fs_installed()
  fs::file_create(where)
}

fs_dir_delete <- function(path) {
  check_fs_installed()
  fs::dir_delete(path)
}

fs_file_delete <- function(path) {
  check_fs_installed()
  fs::file_delete(path)
}

fs_file_exists <- function(path) {
  check_fs_installed()
  fs::file_exists(path)
}

fs_path_abs <- function(path) {
  check_fs_installed()
  fs::path_abs(path)
}

fs_path <- function(..., ext = "") {
  check_fs_installed()
  fs::path(..., ext = ext)
}

fs_file_copy <- function(
  path,
  new_path,
  overwrite = FALSE
) {
  check_fs_installed()
  fs::file_copy(
    path = path,
    new_path = new_path,
    overwrite
  )
}

fs_dir_copy <- function(
  path,
  new_path,
  overwrite = FALSE
) {
  check_fs_installed()
  fs::dir_copy(
    path,
    new_path,
    overwrite
  )
}
