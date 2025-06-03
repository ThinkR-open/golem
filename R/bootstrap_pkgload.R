# All the fns here check that {pkgload} is installed
# before doing anything.
check_pkgload_installed <- function() {
  rlang::check_installed(
    "pkgload",
    reason = "to load the package.",
    version = "1.3.0"
  )
}

pkgload_load_all <- function(
  path = ".",
  reset = TRUE,
  compile = NA,
  attach = TRUE,
  export_all = TRUE,
  export_imports = export_all,
  helpers = TRUE,
  attach_testthat = uses_testthat(path),
  quiet = NULL,
  recompile = FALSE,
  warn_conflicts = TRUE
) {
  check_roxygen2_installed()
  check_pkgload_installed()

  uses_testthat <- getFromNamespace("uses_testthat", "pkgload")
  pkgload::load_all(
    path = path,
    reset = reset,
    compile = compile,
    attach = attach,
    export_all = export_all,
    export_imports = export_imports,
    helpers = helpers,
    attach_testthat = attach_testthat,
    quiet = quiet,
    recompile = recompile,
    warn_conflicts = warn_conflicts
  )
}
