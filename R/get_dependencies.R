#' return all package dependencies from current package
#'
#' @param path path to the package source folder
#' @param dput if FALSE return a vector instead of dput output
#' @param field DESCRIPTION fied to parse, Import and Depends by default
#'
#' @export
#'
#' @examples
#' \dontrun{
#' list_imports()
#' }
#' @importFrom magrittr %>% 
get_dependencies <- function(path='.',dput=TRUE,field=c('Depends','Imports')){
  out <- read.dcf("DESCRIPTION")[,field] %>%
    gsub(pattern = "\n",replacement = "") %>%
    strsplit(",") %>%
    unlist() %>% 
    setNames(NULL)
  out <- out[!grepl("^R [(]", out)]
  
  if ( !dput ){return(out)}
  out %>% dput()
}
