
#' get system requirements
#'
#' @param packages character vector of packages names
#' @param quiet boolean if TRUE the function is quiet
#' @importFrom utils download.file
#' @importFrom jsonlite fromJSON
#' @importFrom tools package_dependencies
get_sysreqs <- function(packages, quiet = TRUE){
  
  # all_deps <- paste(miniCRAN::pkgDep(packages,suggests = FALSE,quiet=quiet), collapse = ",")
  all_deps <- paste(unique(unlist(tools::package_dependencies(packages))), collapse = ",")
all_deps <- c(packages,all_deps)
  url <- sprintf("https://sysreqs.r-hub.io/pkg/%s/linux-x86_64-debian-gcc",all_deps)
path <- tempfile()
utils::download.file(url, path,mode = "wb",quiet = quiet)
out <- jsonlite::fromJSON(path)
unlink(path)
sort(unique(out[!is.na(out)]))
}
