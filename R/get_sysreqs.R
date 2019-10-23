
#' get system requirements
#'
#' @param packages character vector of packages names
#' @param quiet boolean if TRUE the function is quiet
#' @importFrom utils download.file
#' @importFrom jsonlite fromJSON
#' @importFrom remotes package_deps
#' @export
get_sysreqs <- function(packages, quiet = TRUE){
  
  # all_deps <- paste(miniCRAN::pkgDep(packages,suggests = FALSE,quiet=quiet), collapse = ",")
  # all_deps <- paste(unique(c(packages, unlist(miniCRAN::pkgDep(packages, suggests = FALSE)))), collapse = ",")
  all_deps <- paste(unique(c(packages, unlist(remotes::package_deps(packages)$package))), collapse = ",")
  url <- sprintf("https://sysreqs.r-hub.io/pkg/%s/linux-x86_64-debian-gcc",all_deps)
  path <- tempfile()
  utils::download.file(url, path,mode = "wb",quiet = quiet)
  out <- jsonlite::fromJSON(path)
  unlink(path)
  sort(unique(out[!is.na(out)]))
}
