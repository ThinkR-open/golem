#' Return all package dependencies from current package
#'
#' @inheritParams add_module
#' @param path path to the DESCRIPTION file
#' @param dput if TRUE return a dput output instead of character vector
#' @param field DESCRIPTION fields to parse. Default is Import
#'
#' @export
#'
#' @examples
#' \donttest{
#' if (interactive()){
#'   get_dependencies()
#' }
#' }
#' @importFrom stats setNames
get_dependencies <- function(
  path = "DESCRIPTION",
  pkg = get_golem_wd(), 
  dput = FALSE,
  field = c('Imports')
){
  path <- file.path(pkg, path)
  out <- read.dcf(path)[,field] 
  out <- gsub(pattern = "\n",replacement = "", out)
  out <-  unlist(strsplit(out, ",")) 
  out <- setNames(out, NULL)
  
  out <- out[!grepl("^R [(]", out)]
  
  if ( !dput ){
    return(out)
  }
  dput(out)
}
