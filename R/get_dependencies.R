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
#' list_imports()
#' }
#' @importFrom magrittr %>% 
#' @importFrom stats setNames
get_dependencies <- function(path="DESCRIPTION",dput=TRUE,field=c('Depends','Imports')){
  out <- read.dcf(path)[,field] %>%
    gsub(pattern = "\n",replacement = "") %>%
    strsplit(",") %>%
    unlist() %>% 
    setNames(NULL)
  
  out <- out[!grepl("^R [(]", out)]
  
  if ( !dput ){
    return(out)
  }
  dput(out)
}
