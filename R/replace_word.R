replace_word <- function(file,pattern, replace){
  tx  <- readLines(file)
  tx2  <- gsub(pattern = pattern, replace = replace, x = tx)
  writeLines(tx2, con=file)
}