### lib
library(withr)

remove_file <- function(path){
  ok <- file.exists(path)
  if (ok) {
    file.remove(path)
  }
}

## fake package
tpdir <- tempdir()
if(!dir.exists(file.path(tpdir,"pkgtest"))){
  create_golem(file.path(tpdir, "pkgtest"), open = FALSE)
}
pkg <- file.path(tpdir, "pkgtest")