# This script allow you to quick clean your R session
# update documentation and NAMESPACE, localy install the package
# and run the main shinyapp from 'inst/app'
.rs.api.documentSaveAll() # close and save all open file
try(suppressWarnings(lapply(paste("package:", names(sessionInfo()$otherPkgs), sep = ""),
                            detach, character.only = TRUE, unload = TRUE)), silent = TRUE)
rm(list=ls(all.names = TRUE))
devtools::document('.')
devtools::load_all('.')

options(app.prod=FALSE) # TRUE = production mode, FALSE = development mode
shiny::runApp('inst/app')
