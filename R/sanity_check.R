#' Sanity check for R files in the project
#' 
#' This function is used check for any 'browser()' or commented
#' #TODO / #TOFIX / #BUG in the code
#' @rdname sanity_check
#' @export
#' @importFrom rstudioapi sourceMarkers
#' @importFrom rstudioapi getActiveProject
sanity_check<- function(){
  active_project_dir <- rstudioapi::getActiveProject()
  all_R_files <-list.files(path = active_project_dir, pattern = "\\.R$", recursive = TRUE)
  to_find <- c('browser()', '#TODO', '#TOFIX', '#BUG', '# TODO', '# TOFIX', '# BUG')
  source_markers <- data.frame()


  for(file_name in all_R_files){
    file <- readLines(file_name)

    for ( word in to_find){
      line_number <- grep(word, file, fixed = TRUE)
      if(length(line_number) > 0){
        df <- data.frame(
          type = "warning",
          file = file_name,
          line = line_number,
          message = paste("Found", word, sep=" "),
          column = 1
        )
        source_markers <- rbind.data.frame(source_markers, df)
      }
    }
  }

  if(length(source_markers) > 0){
    rstudioapi::sourceMarkers("sanity_check", markers = source_markers)
  }
  else{
    message("No errors found. Sanity check passed successfully.")
  }
}
