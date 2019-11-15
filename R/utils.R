golem_sys <- function(
  ..., 
  lib.loc = NULL, 
  mustWork = FALSE
){
  system.file(
    ..., 
    package = "golem", 
    lib.loc = lib.loc, 
    mustWork = mustWork
  )
}

#  from usethis https://github.com/r-lib/usethis/
darkgrey <- function(x) {
  x <- crayon::make_style("darkgrey")(x)
}

dir_not_exist <- Negate(dir.exists)
file_not_exist <- Negate(file.exists)

is_package <- function(path){
  x <- attempt::attempt({
    pkgload::pkg_path()
  })
  !attempt::is_try_error(x)
}

create_if_needed <- function(
  path, 
  type = c("file", "directory"),
  content = NULL
){
  type <- match.arg(type)
  # Check if file or dir already exist
  if (type == "file"){
    dont_exist <- file_not_exist(path)
  } else if (type == "directory"){
    dont_exist <- dir_not_exist(path)
  }
  # If it doesn't exist, ask if we are allowed 
  # to create it
  if (dont_exist){
    ask <- yesno::yesno(
      sprintf(
        "The %s %s doesn't exist, create?", 
        basename(path), 
        type
      )
    )
    # Return early if the user doesn't allow 
    if (!ask) return(FALSE)
    
  } else {
    return(TRUE)
  }
  
  # Create the file 
  if (type == "file"){
    fs::file_create(path)
    write(content, path, append = TRUE)
  } else if (type == "directory"){
    fs::dir_create(path, recurse = TRUE)
  }
  # TRUE means that file exists (either 
  # created or already there)
  return(TRUE)
}

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

remove_comments <- function(file) {
  lines <- readLines(file)
  lines_without_comment <- c()
  for ( line in lines ) {
    lines_without_comment <- append(
      lines_without_comment, 
      gsub("(\\s*#+[^'@].*$| #+[^#].*$)", "", line)
    )
  }
  lines_without_comment <- lines_without_comment[lines_without_comment != ""]
  writeLines(text = lines_without_comment, con = file)
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
