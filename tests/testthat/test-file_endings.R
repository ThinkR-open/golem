bad_last_line <- function(file){
  bad_file <- tryCatch({
    readLines(con = file)
  }, warning = function(w){
    return(TRUE)
  })
  if (typeof(bad_file) == "logical"){
    return(TRUE)
  }
  FALSE
}

files_with_bad_lines <- function(){
  r_files <- list.files(pattern = ".*R$", recursive = TRUE)
  last_lines <- r_files %>%
    purrr::map_lgl(bad_last_line)
  
  invalid_r_file <- function(r_file){
    if (last_lines[which(r_files == r_file)]){
      return(TRUE)
    }
    FALSE
  }
  
  Filter(invalid_r_file, r_files)
}

add_final_empty_line <- function(files){
  purrr::walk(files, function(file){
    write("\n", file = file, append = TRUE)
  })
}

test_that("proper_file_endings", {
  bad_files <- files_with_bad_lines()
  expect_equal(length(bad_files), 0)
})
