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

# From {dockerfiler}, in wait for the version to be on CRAN
#' @importFrom utils installed.packages
dock_from_desc <- function(
  path = "DESCRIPTION",
  FROM = "rocker/r-base",
  AS = NULL
){
  
  x <- dockerfiler::Dockerfile$new(FROM, AS)
  x$RUN("R -e 'install.packages(\"remotes\")'")
  
  # We need to be sure install_cran is there
  x$RUN("R -e 'remotes::install_github(\"r-lib/remotes\", ref = \"6c8fdaa\")'")
  
  desc <- read.dcf(path)
  
  # Handle cases where there is no deps
  imp <- attempt::attempt({
    desc[, "Imports"]
  }, silent = TRUE)
  
  if (class(imp)[1] != "try-error"){
    # Remove base packages which are not on CRAN
    # And shouldn't be installed
    reco <- rownames(installed.packages(priority="base"))
    
    # And Remotes package, which will be handled 
    # by install_local
    rem <- attempt::attempt({
      desc[, "Remotes"]
    }, silent = TRUE)
    
    if (class(rem)[1] != "try-error"){
      rem <- strsplit(rem, "\n")[[1]]
      rem <- vapply(rem, function(x){
        strsplit(x, "/")[[1]][2]
      }, character(1))
      reco <- c(reco, unname(rem))
    }
    
    if (length(imp) > 0) {
      imp <- gsub(",", "", imp)
      imp <- strsplit(imp, "\n")[[1]]
      for (i in seq_along(imp)){
        if (!(imp[i] %in% reco)){
          x$RUN(paste0("R -e 'remotes::install_cran(\"", imp[i], "\")'"))
        }
      }
    }
  }
  
  x$COPY(
    from = paste0(desc[1], "_*.tar.gz"),
    to = "/app.tar.gz"
  )
  x$RUN("R -e 'remotes::install_local(\"/app.tar.gz\")'")
  
  x
}