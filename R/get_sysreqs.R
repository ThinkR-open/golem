
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
#' @export
get_sysreqs <- function(packages, quiet = TRUE,batch_n=30){
  
  all_deps <- sort(
    unique(
      c(packages, unlist( remotes::package_deps(packages)$package )
      )
    )
  )
  
sp <-   split(
    all_deps, 
    ceiling(
      seq_along(all_deps) / batch_n
    )
  ) 


sort(unique(unname(unlist(
  
  # map(sp, ~ get_batch_sysreqs(.x, quiet = quiet))
  lapply(sp, function(.x){ get_batch_sysreqs(.x, quiet = quiet) })
  
  
))))

}

#' @importFrom fs file_delete  file_temp
get_batch_sysreqs <- function(
  all_deps,
  quiet=TRUE
){
  
  url <- sprintf(
    "https://sysreqs.r-hub.io/pkg/%s/linux-x86_64-debian-gcc",
    paste(all_deps, collapse = ",")
  )
  path <- file_temp()
  utils::download.file(
    url, 
    path,
    mode = "wb",
    quiet = quiet
  )
  out <- jsonlite::fromJSON(path)
  file_delete(path)
  unique(out[!is.na(out)])
  
}
