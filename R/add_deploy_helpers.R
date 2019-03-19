#' Add an app.R at the root of your package to deploy on RStudio Connect
#'
#' @param pkg Where to put the app.R.
#' @inheritParams add_module
#' @importFrom cli cat_bullet
#' @export
#' 
add_rconnect_file <- function(
  pkg = "."
){
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
#' @param from The FROM of the Dockerfile. Default is FROM rocker/tidyverse:
#'     with `R.Version()$major` and `R.Version()$minor`.
#'
#' @importFrom dockerfiler dock_from_desc
#' @export
#' @rdname dockerfiles
#' @examples
#' \dontrun{
#' add_shinyproxy_dockerfile()
#'}
add_shinyproxy_dockerfile <- function( 
  input = "DESCRIPTION", 
  output = "Dockerfile", 
  from = paste0(
    "rocker/tidyverse:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL
){
  where <- file.path(output)
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  dock <- dock_from_desc(input, FROM = from, AS = as)
  dock$EXPOSE(3838)
  dock$CMD(glue::glue(
    " [\"R\", \"-e options('shiny.port'=3838,shiny.host='0.0.0.0'); {read.dcf(input)[1]}::run_app()\"]"
  ))
  dock$write(output)
  
  cat_green_tick(
    glue("Dockerfile created at {output}")
  )
  
  alert_build(input, output)
  
  usethis::use_build_ignore(files = output)
  
  invisible(output)
  
}

#' @export
#' @rdname dockerfiles
add_heroku_dockerfile <- function( 
  input = "DESCRIPTION", 
  output = "Dockerfile", 
  from = paste0(
    "rocker/tidyverse:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL
){
  where <- file.path(output)
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  
  dock <- dock_from_desc(input, FROM = from, AS = as)
  
  dock$CMD(glue::glue(
    " [\"R\", \"-e options('shiny.port'=$PORT,shiny.host='0.0.0.0'); {read.dcf(input)[1]}::run_app()\"]"
  ))
  dock$write(output)
  
  cat_green_tick(
    glue("Dockerfile created at {output}")
  )
  
  apps_h <- gsub("\\.", "-", glue("{read.dcf(input)[1]}-{read.dcf('DESCRIPTION')[1,][['Version']]}"))
  
  alert_build(input, output)
  
  cat_rule( "From your command line, run:" )
  cat_line("heroku container:login")
  cat_line(
    glue("heroku create {apps_h}")
  ) 
  cat_line(
    glue("heroku container:push web --app {apps_h}")
  )
  cat_line(
    glue("heroku container:release web --app {apps_h}")
  )
  cat_line(
    glue("heroku open {apps_h}")
  )
  cat_red_bullet("Be sure to have the heroku CLI installed.")
  cat_red_bullet(
    glue("You can replace {apps_h} with another app name.")
  )
  
  usethis::use_build_ignore(files = output)
  
  invisible(output)
  
}

alert_build <- function(input, output){
  cat_red_bullet(
    glue::glue(
      "Be sure to put your {read.dcf(input)[1]}_{read.dcf(input)[1,][['Version']]}.tar.gz file (generated using `devtools::build()` ) in the same folder as the {basename(output)} file generated"
    )
  )
}