#' Return all package dependencies from current package
#'
#' @param path path to the DESCRIPTION file
#' @param dput if FALSE return a vector instead of dput output
#' @param field DESCRIPTION fields to parse. Default is Import and Depends
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_dependencies()
#' }
#' @importFrom stats setNames
get_dependencies <- function(path="DESCRIPTION",dput=TRUE,field=c('Depends','Imports')){
  out <- read.dcf(path)[,field] 
  out <-  gsub(pattern = "\n",replacement = "", out) 
  out <- unlist(strsplit(out, ","))
  out <- setNames(out, NULL)
  
  out <- out[!grepl("^R [(]", out)]
  
  if ( !dput ){
    return(out)
  }
  dput(out)
}
