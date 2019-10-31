
#' get system requirements
#'
#' @param packages character vector of packages names
#' @param batch_n number of simultaneous packages to ask
#' @param quiet boolean if TRUE the function is quiet
#'
#' @importFrom utils download.file
#' @importFrom jsonlite fromJSON
#' @importFrom remotes package_deps
#' @importFrom purrr map
#' @importFrom magrittr %>% 
#' @export
get_sysreqs <- function(packages, quiet = TRUE,batch_n=30){
  
  # all_deps <- paste(miniCRAN::pkgDep(packages,suggests = FALSE,quiet=quiet), collapse = ",")
  # all_deps <- paste(unique(c(packages, unlist(miniCRAN::pkgDep(packages, suggests = FALSE)))), collapse = ",")
  all_deps <- sort(unique(c(packages, unlist(remotes::package_deps(packages)$package))))
  all_deps
  
  split(all_deps, ceiling(seq_along(all_deps)/batch_n)) %>%
    map(~get_batch_sysreqs(.x,quiet=quiet)) %>% 
    unlist() %>% 
    unname() %>% 
    unique() %>% 
    sort()

}


get_batch_sysreqs <- function(all_deps,quiet=TRUE){
  
  all_deps<-paste(all_deps  , collapse = ",")
  
  
  url <- sprintf("https://sysreqs.r-hub.io/pkg/%s/linux-x86_64-debian-gcc",all_deps)
  path <- tempfile()
  utils::download.file(url, path,mode = "wb",quiet = quiet)
  out <- jsonlite::fromJSON(path)
  unlink(path)
  
  
  
  sort(unique(out[!is.na(out)]))
  
}
