#' Add an app.R at the root of your package to deploy on RStudio Connect
#'
#' @param pkg Where to put the app.R.
#' @inheritParams add_module
#' @importFrom cli cat_bullet
#' @export
add_rconnect_file <- function(
  pkg = "."
){
  where <- file.path(pkg, "app.R")
  
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
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
  cat_green_tick(glue("File created at {where}"))
  cat_line("To deploy, run:")
  cat_bullet(darkgrey("rsconnect::deployApp()\n"))
  
  
  if (rstudioapi::isAvailable()){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(
      glue::glue("Go to {where}")
    )
  }
  
}

#' Create a Dockerfile for  Shiny App 
#' 
#' Build a container containing your Shiny App. `add_dockerfile()` creates 
#' a "generalistic" Dockerfile, while `add_shinyproxy_dockerfile()` and 
#' `add_heroku_dockerfile()` creates plateform specific Dockerfile.
#'
#' @param input path to the DESCRIPTION file to use as an input.
#' @param output name of the Dockerfile output.
#' @param from The FROM of the Dockerfile. Default is FROM rocker/tidyverse:
#'     with `R.Version()$major` and `R.Version()$minor`.
#' @param as The AS of the Dockerfile. Default it NULL. 
#' @param port The `options('shiny.port')` on which to run the Shiny App.
#'     Default is 80.  
#' @param host The `options('shiny.host')` on which to run the Shiny App.
#'    Default is 0.0.0.0.  
#' @importFrom dockerfiler dock_from_desc
#' @export
#' @rdname dockerfiles
#' @examples
#' \dontrun{
#' add_dockerfile()
#' add_shinyproxy_dockerfile()
#' add_heroku_dockerfile()
#'}

add_dockerfile <- function(
  input = "DESCRIPTION", 
  output = "Dockerfile", 
  from = paste0(
    "rocker/tidyverse:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL, 
  port = 80, 
  host = "0.0.0.0"
) {
  
  where <- file.path(output)
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
  dock <- dock_from_desc(input, FROM = from, AS = as)
  dock$EXPOSE(port)
  dock$CMD(
    glue::glue(
      "R -e \"options('shiny.port'={port},shiny.host={host});{read.dcf(input)[1]}::run_app()\""
    )
  )
  dock$write(output)
  alert_build(input, output)
  
}

#' @export
#' @rdname dockerfiles
add_dockerfile_shinyproxy <- function( 
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
  
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
  dock <- dock_from_desc(input, FROM = from, AS = as)
  
  dock$EXPOSE(3838)
  dock$CMD(glue::glue(
    " [\"R\", \"-e options('shiny.port'=3838,shiny.host='0.0.0.0'); {read.dcf(input)[1]}::run_app()\"]"
  ))
  dock$write(output)
  
  alert_build(input, output)
  
  usethis::use_build_ignore(files = output)
  
  invisible(output)
  
}

#' @export
#' @rdname dockerfiles
add_dockerfile_heroku <- function( 
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
  
  dock$CMD(
    glue::glue(
      "R -e \"options('shiny.port'=$PORT,shiny.host='0.0.0.0');{read.dcf(input)[1]}::run_app()\""
    )
  )
  dock$write(output)
  
  alert_build(input, output)
  
  apps_h <- gsub(
    "\\.", "-", 
    glue("{read.dcf(input)[1]}-{read.dcf('DESCRIPTION')[1,][['Version']]}")
  )
  
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
    glue("heroku open --app {apps_h}")
  )
  cat_red_bullet("Be sure to have the heroku CLI installed.")
  cat_red_bullet(
    glue("You can replace {apps_h} with another app name.")
  )
  
  usethis::use_build_ignore(files = output)
  invisible(output)
  
}

alert_build <- function(input, output){
  cat_green_tick(
    glue("Dockerfile created at {output}")
  )
  cat_red_bullet(
    glue::glue(
      "Be sure to put your {read.dcf(input)[1]}_{read.dcf(input)[1,][['Version']]}.tar.gz file (generated using `devtools::build()` ) in the same folder as the {basename(output)} file generated"
    )
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
  x$RUN("R -e 'remotes::install_github(\"r-lib/remotes\", ref = \"97bbf81\")'")
  
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