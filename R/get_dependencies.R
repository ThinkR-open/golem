#' Return all package dependencies from current package
#'
#' @param path path to the DESCRIPTION file
#' @param dput if TRUE return a dput output instead of character vector
#' @param field DESCRIPTION fields to parse. Default is Import
#'
#' @export
#'
#' @examples
#' \donttest{
#' get_dependencies()
#' }
#' @importFrom stats setNames
get_dependencies <- function(path="DESCRIPTION",dput=FALSE,field=c('Imports')){
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
