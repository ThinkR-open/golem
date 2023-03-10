# All the fns here check that {attachment} is installed
# before doing anything.
check_attachment_installed <- function() {
  rlang::check_installed(
    "attachment",
    version = "0.3.1",
    reason = "to build a Dockerfile."
  )
}

attachment_create_renv_for_prod <- function(
  path = ".",
  output = "renv.lock.prod",
  dev_pkg = "remotes",
  check_if_suggests_is_installed = FALSE,
  document = FALSE,
  ...
) {
  attachment::create_renv_for_prod(
    path = path,
    output = output,
    dev_pkg = dev_pkg,
    document = document,
    check_if_suggests_is_installed = check_if_suggests_is_installed,
    ...
  )
}
