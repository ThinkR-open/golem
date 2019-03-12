#' Add an app.R at the root of your package to deploy on RStudio Connect
#'
#' @inheritParams add_module
#' @importFrom cli cat_bullet
#' @export
add_rconnect_file <- function(pkg = "."){
  
  where <- file.path(pkg, "app.R")
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  write_there <- function(..., here = where){
    write(..., here, append = TRUE)
  }
  file.create( where )
  usethis::use_build_ignore( where )
  write_there("# To deploy, run: rsconnect::deployApp()")
  write_there("")
  write_there("pkgload::load_all()")
  write_there("options( \"golem.app.prod\" = TRUE)")
  write_there("shiny::shinyApp(ui = app_ui(), server = app_server)")
  usethis::use_build_ignore(where)
  usethis::use_package("pkgload")
  cat_bullet(glue("File created at {where}"), bullet = "tick", bullet_col = "green")
  cat_bullet("To deploy, run:")
  cat(darkgrey("rsconnect::deployApp()\n"))
  
  
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_bullet(
      glue::glue("Go to {where}"), 
      bullet = "square_small_filled", 
      bullet_col = "red"
    )
  }
  
}

#' Create a Dockerfile for  Shiny App 
#' 
#' Build a container containing your Shiny App.
#'
#' @param input path to the DESCRIPTION file to use as an input.
#' @param output name of the Dockerfile output.
#'
#' @export
#' @examples
#' \dontrun{
#' add_dockerfile()
#'}
add_dockerfile <- function( input = "DESCRIPTION", output = "Dockerfile" ){
  where <- file.path(output)
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  docker <- c(
    glue::glue("FROM rocker/tidyverse:{major}.{minor}",major= R.Version()$major,minor= R.Version()$minor),
    glue::glue('RUN R -e "install.packages(\'remotes\')"'),
    glue::glue('RUN R -e "remotes::install_cran(\'{hop}\')"',
               hop =att_from_description(path = path)),
    glue::glue("COPY {read.dcf(path)[1]}_*.tar.gz  /app.tar.gz"),
    "RUN R -e \"install.packages('/app.tar.gz', repos = NULL, type = 'source')\"",
    
    "EXPOSE 3838",
    glue::glue("CMD [\"R\", \"-e options('shiny.port'=3838,shiny.host='0.0.0.0');{read.dcf(path)[1]}::run_app()\"]"))
  docker <- paste(docker,collapse = " \n")
  cat(docker,file=output)
  cat_bullet(glue::glue("Be sure to put your {read.dcf(path)[1]}_{read.dcf('DESCRIPTION')[1,][['Version']]}.tar.gz file (generated using devtools::build() ) in the same folder as the {basename(output)} file generated"))
  usethis::use_build_ignore(files = output)
  
  invisible(output)
}

