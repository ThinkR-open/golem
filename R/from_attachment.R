#' Return all package dependencies from current package
#'
#' @param path path to the DESCRIPTION file
#' @param dput if FALSE return a vector instead of dput output
#' @param field DESCRIPTION fied to parse, Import and Depends by default
#'
#' @return A character vector with packages names
#'
#' @export
#' @importFrom stringr str_replace_all str_trim
#'
#' @examples
#'
#' dummypackage <- system.file("dummypackage",package = "attachment")
#' # browseURL(dummypackage)
#' att_from_description(path = file.path(dummypackage,"DESCRIPTION"))
#'
att_from_description <- function(path = "DESCRIPTION", dput = FALSE,
                                 field = c("Depends", "Imports", "Suggests")) {
  out <- read.dcf(path)
  out <- out[, intersect(colnames(out), field)] %>%
    gsub(pattern = "\n", replacement = "") %>%
    strsplit(",") %>%
    unlist() %>%
    setNames(NULL)
  out <- out[!grepl("^R [(]", out)] %>%
    str_replace_all("\\(.+\\)","") %>%
    str_trim() %>%
    unique() %>%
    sort()
  
  
  
  if (!dput) {
    return(out)
  }
  dput(out)
}
