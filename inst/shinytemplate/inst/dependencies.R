# This script have to be regularly update to contains all 
# dependances needed to launch the app ()

# this instruction create the vector you need
# read.dcf("DESCRIPTION")[,"Imports"] %>%
#   str_replace_all("\n","") %>% 
#   str_split(",") %>% 
#   unlist() %>% 
#   dput()


to_install <- c("DT",
                "graphics",
                "shiny",
                "stats",
                "glue")
for (i in to_install) {
  message(paste("looking for ", i))
  if (!requireNamespace(i)) {
    message(paste("     installing", i))
    install.packages(i)
  }
  
}