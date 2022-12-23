# All the fns here check that {desc} is installed
# before doing anything.
check_desc_installed <- function() {
  rlang::check_installed(
    "desc",
    reason = "to fill DESCRIPTION."
  )
}

desc_description <- function(file) {
  check_desc_installed()
  desc::description$new(
    file = file
  )
}

desc_get <- function(keys) {
  check_desc_installed()
  desc::desc_get(keys)
}

desc_get_version <- function() {
  check_desc_installed()
  desc::desc_get_version()
}

desc_get_deps <- function(file = NULL) {
  check_desc_installed()
  desc::desc_get_deps(file)
}

desc_get_field <- function(key) {
  check_desc_installed()
  desc::desc_get_field(key)
}

desc_get_author <- function() {
  check_desc_installed()
  desc::desc_get_author()
}
