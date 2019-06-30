### lib
library(withr)

remove_file <- function(path){
  ok <- file.exists(path)
  if (ok) {
    file.remove(path)
  }
}

## fake package
fakename <- paste0(sample(letters, 10, TRUE), collapse = "")
tpdir <- tempdir()
if(!dir.exists(file.path(tpdir,fakename))){
  create_golem(file.path(tpdir, fakename), open = FALSE)
}
pkg <- file.path(tpdir, fakename)

