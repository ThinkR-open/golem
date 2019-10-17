### lib
library(withr)
#unlink(list.files(tempdir(), full.names = TRUE), recursive = TRUE)

remove_file <- function(path){
  if (file.exists(path)) file.remove(path)
}

## fake package
fakename <- paste0(sample(letters, 10, TRUE), collapse = "")
#unlink(list.files(tempdir()), recursive = TRUE)
tpdir <- tempdir()
if(!dir.exists(file.path(tpdir,fakename))){
  create_golem(file.path(tpdir, fakename), open = FALSE)
}
pkg <- file.path(tpdir, fakename)

## random dir
randir <- paste0(sample(letters, 10, TRUE), collapse = "")
fp <- file.path("inst/app", randir)
dir.create(file.path(pkg, fp), recursive = TRUE)

rand_name <- function(){
  paste0(sample(letters, 10, TRUE), collapse = "")
}

set_golem_wd(pkg)
orig_test <- usethis::proj_get()
usethis::proj_set(pkg)