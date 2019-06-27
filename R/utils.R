golem_sys <- function(..., lib.loc = NULL, mustWork = FALSE){
  system.file(..., package = "golem", lib.loc = lib.loc, mustWork = mustWork)
}

#  from usethis https://github.com/r-lib/usethis/
darkgrey <- function(x) {
  x <- crayon::make_style("darkgrey")(x)
}

check_file_exist <- function(file){
  res <- TRUE 
  if (file.exists(file)){
    res <- yesno::yesno("This file already exists, override?")
  }
  return(res)
}
check_dir_exist <- function(dir){
  if (! dir.exists(dir) ) {
    cli::cat_rule("This directory doesn't exist, creating...")
    dir.create(dir, recursive = TRUE)
    cat_green_tick(
      sprintf(
        "Directory created at %s", 
        dir
      )
    )
  }
}

# internal
replace_word <- function(file,pattern, replace){
  suppressWarnings( tx  <- readLines(file) )
  tx2  <- gsub(pattern = pattern, replacement = replace, x = tx)
  writeLines(tx2, con=file)
}

cat_green_tick <- function(...){
  cat_bullet(
    ..., 
    bullet = "tick", 
    bullet_col = "green"
  )
}

cat_red_bullet <- function(...){
  cat_bullet(
    ..., 
    bullet = "bullet",
    bullet_col = "red"
  )
}
