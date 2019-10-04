golem_sys <- function(..., lib.loc = NULL, mustWork = FALSE){
  system.file(..., package = "golem", lib.loc = lib.loc, mustWork = mustWork)
}

#  from usethis https://github.com/r-lib/usethis/
darkgrey <- function(x) {
  x <- crayon::make_style("darkgrey")(x)
}

msgRed <- function(x) {
  x <- crayon::make_style("red")(x)
}

dir_not_exist <- Negate(dir.exists)
file_not_exist <- Negate(file.exists)

create_dir_if_needed <- function(
  path, 
  auto_create
){
  # TRUE if path doesn't exist
  dir_not_there <- dir_not_exist(path) 
  go_create <- TRUE
  # If not exists, maybe create it
  if (dir_not_there){
    # Auto create if needed
    if (auto_create){
      go_create <- TRUE
    } else {
      # Ask for creation
      go_create <- yesno::yesno(sprintf("The %s does not exists, create?", path))
    }
    # Will create if autocreate or if yes to interactive
    if (go_create) {
      dir.create(path, recursive = TRUE)
      cat_green_tick(
        sprintf(
          "Created folder %s to receive the file", 
          path
        )
      )
    } 
  }
  
  return(go_create)
}

check_file_exist <- function(file){
  res <- TRUE
  if (file.exists(file)){
    res <- yesno::yesno("This file already exists, override?")
  }
  return(res)
}
check_dir_exist <- function(dir){
  res <- TRUE
  if (!dir.exists(dir)){ 
    res <- yesno::yesno(sprintf("The %s does not exists, create?", dir))
  }
  return(res)
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
