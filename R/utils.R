check_file_exist <- function(file){
  res <- TRUE
  if (file.exists(file)){
    res <- yesno::yesno("This file already exists, override?")
  }
  return(res)
}