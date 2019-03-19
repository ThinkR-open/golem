check_file_exist <- function(file){
  res <- TRUE
  if (file.exists(file)){
    res <- yesno::yesno("This file already exists, override?")
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