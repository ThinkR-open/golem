### lib
library(golem)
library(withr)
old_usethis.quiet <- getOption("usethis.quiet")
options("usethis.quiet" = TRUE)
# Small hack to prevent warning from rlang::lang() in tests
# This should be managed in {attempt} later on
x <- suppressWarnings({
  rlang::lang(print)
})

### Funs
remove_file <- function(path) {
  if (file.exists(path)) unlink(path, force = TRUE)
}

remove_files <- function(path, pattern = NULL) {
  fls <- list.files(
    path,
    pattern,
    full.names = TRUE,
    recursive = TRUE
  )
  if (length(fls) > 0) {
    res <- lapply(fls, function(x) {
      if (file.exists(x)) unlink(x, force = TRUE)
    })
  }
}

expect_exists <- function(fls) {
  act <- list(
    val = fls,
    lab = fls
  )

  act$val <- file.exists(fls)
  expect(
    isTRUE(act$val),
    sprintf("File %s doesn't exist.", fls)
  )

  invisible(act$val)
}

burn_after_reading <- function(file, exp) {
  unlink(file, force = TRUE)
  force(exp)
  unlink(file, force = TRUE)
}

# We prevent the random name from having
# ui or server inside it
safe_let <- function() {
  letters[-c(5, 9, 18, 19, 21, 22)]
}

## fake package
fakename <- sprintf(
  "%s%s",
  paste0(sample(safe_let(), 10, TRUE), collapse = ""),
  gsub("[ :-]", "", Sys.time())
)


## random dir
randir <- paste0(sample(safe_let(), 10, TRUE), collapse = "")

tpdir <- normalizePath(tempdir())
unlink(file.path(tpdir, fakename), recursive = TRUE)
create_golem(file.path(tpdir, fakename), open = FALSE)
pkg <- file.path(tpdir, fakename)

fp <- file.path("inst/app", randir)
dir.create(file.path(pkg, fp), recursive = TRUE)

rand_name <- function() {
  paste0(sample(safe_let(), 10, TRUE), collapse = "")
}

withr::with_dir(pkg, {
  set_golem_options()
  usethis::proj_set(pkg)
  orig_test <- set_golem_wd(
    pkg = pkg,
    )
  usethis::use_mit_license("Golem")
})
