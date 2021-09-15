# Now in {dockerfiler}

#' Get system requirements (Deprecated)
#'
#' This function retrieves information about the 
#' system requirements using the <https://sysreqs.r-hub.io> 
#' API. This function is now deprecated, and was moved to 
#' {dockerfiler}.
#'
#' @param packages character vector. Packages names.
#' @param batch_n numeric. Number of simultaneous packages to ask.
#' @param quiet Boolean. If `TRUE` the function is quiet.
#'
#' 
#' @export
#' 
#' @return A vector of system requirements.
get_sysreqs <- function(
  packages, 
  quiet = TRUE,
  batch_n = 30
){
  .Deprecated(
    "dockerfiler::get_sysreqs", 
    msg = "get_sysreqs() is deprecated and has been moved to {dockerfiler}."
  )
  # 
  # all_deps <- sort(
  #   unique(
  #     c(
  #       packages, 
  #       unlist( 
  #         remotes::package_deps(packages)$package 
  #       )
  #     )
  #   )
  # )
  # 
  # sp <-   split(
  #   all_deps, 
  #   ceiling(
  #     seq_along(all_deps) / batch_n
  #   )
  # ) 
  # 
  # 
  # sort(
  #   unique(
  #     unname(
  #       unlist(
  #         lapply(
  #           sp, 
  #           function(.x){ 
  #             get_batch_sysreqs(
  #               .x, quiet = quiet
  #             ) 
  #           }
  #         )
  #       )
  #     )
  #   )
  # )
  
}

# Now in {dockerfiler}

#' #' @importFrom fs file_delete  file_temp
#' get_batch_sysreqs <- function(
#'   all_deps,
#'   quiet=TRUE
#' ){
#'   
#'   url <- sprintf(
#'     "https://sysreqs.r-hub.io/pkg/%s/linux-x86_64-debian-gcc",
#'     paste(all_deps, collapse = ",")
#'   )
#'   path <- file_temp()
#'   utils::download.file(
#'     url, 
#'     path,
#'     mode = "wb",
#'     quiet = quiet
#'   )
#'   out <- jsonlite::fromJSON(path)
#'   file_delete(path)
#'   unique(out[!is.na(out)])
#'   
#' }
