# All the fns here check that {attachment} is installed
# before doing anything.
check_attachment_installed <- function() {
  rlang::check_installed(
    "attachment",
    version = "0.3.0.9001",
    reason = "to build a Dockerfile."
  )
}

attachment_create_renv_for_prod <- function(
  path = ".",
  output = "renv.lock.prod",
  dev_pkg = "remotes",
  check_if_suggests_is_installed = FALSE,
  ...
) {
  attachment::create_renv_for_prod(
    path = path,
    output = output,
    dev_pkg = dev_pkg,
    check_if_suggests_is_installed = check_if_suggests_is_installed,
    ...
  )
}
