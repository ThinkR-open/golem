### lib
library(withr)

### Funs

remove_file <- function(path){
  if (file.exists(path)) unlink(path, force = TRUE)
}

remove_files <- function(path, pattern = NULL){
  fls <- list.files(
    path, pattern, full.names = TRUE, recursive = TRUE
  )
  if (length(fls) >0){
    res <- lapply(fls, function(x){
      if (file.exists(x)) unlink(x, force = TRUE)
    })
  }
}

expect_exists <- function(fls) {
  
  act <- quasi_label(rlang::enquo(fls), arg = "fls")
  
  act$val <- file.exists(fls)
  expect(
    isTRUE(act$val),
    sprintf("File %s doesn't exist.", fls)
  )
  
  invisible(act$val)
}


## fake package
fakename <- sprintf(
  "%s%s",
  paste0(sample(letters, 10, TRUE), collapse = ""),
  gsub("[ :-]", "", Sys.time())
  )

tpdir <- normalizePath(tempdir())
unlink(file.path(tpdir,fakename), recursive = TRUE)
create_golem(file.path(tpdir, fakename), open = FALSE)
pkg <- file.path(tpdir, fakename)

## random dir
randir <- paste0(sample(letters, 10, TRUE), collapse = "")
fp <- file.path("inst/app", randir)
dir.create(file.path(pkg, fp), recursive = TRUE)

rand_name <- function(){
  paste0(sample(letters, 10, TRUE), collapse = "")
}

withr::with_dir(pkg, {
  set_golem_options()
})

orig_test <- set_golem_wd(pkg)
usethis::proj_set(pkg)
