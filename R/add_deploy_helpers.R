#' @importFrom utils capture.output
#' @importFrom cli cat_bullet
#' @importFrom usethis use_build_ignore use_package
#' @importFrom pkgload pkg_name
add_rstudio_files <- function(
  pkg,
  open, 
  service = c("RStudio Connect", "Shiny Server", "ShinyApps.io")
){
  service <- match.arg(service)
  where <- file.path(pkg, "app.R")
  
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  
  write_there <- function(..., here = where){
    write(..., here, append = TRUE)
  }
  file.create( where )
  use_build_ignore( basename(where) )
  write_there("# Launch the ShinyApp (Do not remove this comment)")
  write_there("# To deploy, run: rsconnect::deployApp()")
  write_there("# Or use the blue button on top of this file")
  write_there("")
  write_there("pkgload::load_all()")
  write_there("options( \"golem.app.prod\" = TRUE)")
  write_there(
    sprintf(
      "%s::run_app() # add parameters here (if any)", 
      getOption("golem.app.name", pkg_name())
    )
  )
  #use_build_ignore(where)
  x <- capture.output(use_package("pkgload"))
  cat_green_tick(glue("File created at {where}"))
  cat_line("To deploy, run:")
  cat_bullet(darkgrey("rsconnect::deployApp()\n"))
  cat_red_bullet(
    sprintf(
      "Note that you'll need to upload the whole package to %s",
      service
    )
  )
  
  
  if (rstudioapi::isAvailable() & open){
    rstudioapi::navigateToFile(where)
  } else {
    cat_red_bullet(
      sprintf("Go to %s", where)
    )
  }
}

#' Add an app.R at the root of your package to deploy on RStudio Connect
#'
#' @note 
#' In previous versions, this function was called add_rconnect_file.
#'
#' @inheritParams add_module
#' @param pkg Where to put the app.R.
#' @param open Open the file
#' @aliases add_rconnect_file add_rstudioconnect_file
#' @export
#' @rdname rstudio_deploy
#' @examples
#' \donttest{
#' # Add a file for Connect
#' if (interactive()){
#'    add_rstudioconnect_file()
#' }
#' # Add a file for Shiny Server
#' if (interactive()){
#'     add_shinyserver_file()
#' }
#' # Add a file for Shinyapps.io
#' if (interactive()){
#'     add_shinyappsio_file()
#' }
#'}
add_rstudioconnect_file <- function(
  pkg = get_golem_wd(), 
  open = TRUE
){
  add_rstudio_files(pkg = pkg, open = open, service = "RStudio Connect")
}

#' @rdname rstudio_deploy
#' @export
add_shinyappsio_file <- function(
  pkg = get_golem_wd(), 
  open = TRUE
  ){
  add_rstudio_files(pkg = pkg, open = open, service = "ShinyApps.io")
}

#' @rdname rstudio_deploy
#' @export
add_shinyserver_file <- function(
  pkg = get_golem_wd(), 
  open = TRUE
  ){
  add_rstudio_files(pkg = pkg, open = open, service = "Shiny Server")
}

#' Create a Dockerfile for  Shiny App 
#' 
#' Build a container containing your Shiny App. `add_dockerfile()` creates 
#' a "classical" Dockerfile, while `add_dockerfile_shinyproxy()` and 
#' `add_dockerfile_heroku()` creates platform specific Dockerfile.
#'
#' @inheritParams  add_module
#' @param path path to the DESCRIPTION file to use as an input.
#' @param output name of the Dockerfile output.
#' @param from The FROM of the Dockerfile. Default is FROM rocker/r-ver:
#'     with `R.Version()$major` and `R.Version()$minor`.
#' @param as The AS of the Dockerfile. Default it NULL. 
#' @param port The `options('shiny.port')` on which to run the Shiny App.
#'     Default is 80.  
#' @param host The `options('shiny.host')` on which to run the Shiny App.
#'    Default is 0.0.0.0.  
#' @param sysreqs boolean to check the system requirements    
#' @param repos character vector, the base URL of the repositories  
#' @param expand boolean, if `TRUE` each system requirement will be known his own RUN line
#' @export
#' @rdname dockerfiles
#' @importFrom desc desc_get_deps
#' @importFrom dockerfiler Dockerfile
#' @examples
#' \donttest{
#' # Add a standard Dockerfile
#' if (interactive()){
#'    add_dockerfile()
#' }
#' # Add a Dockerfile for ShinyProxy
#' if (interactive()){
#'     add_dockerfile_shinyproxy()
#' }
#' # Add a Dockerfile for Heroku
#' if (interactive()){
#'     add_dockerfile_heroku()
#' }
#'}

add_dockerfile <- function(
  path = "DESCRIPTION", 
  output = "Dockerfile", 
  pkg = get_golem_wd(), 
  from = paste0(
    "rocker/r-ver:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL, 
  port = 80, 
  host = "0.0.0.0",
  sysreqs = TRUE,
  repos = "https://cran.rstudio.com/",
  expand = FALSE
  # ,  function_to_launch = "run_app"
) {
  
  
  where <- file.path(pkg, output) 
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  usethis::use_build_ignore(basename(where))
  
  
  
  
  dock <- dock_from_desc(path = path, FROM = from, AS = as, sysreqs = sysreqs, repos = repos,expand = expand)
  dock$EXPOSE(port)
  dock$CMD(
    glue::glue(
      "R -e \"options('shiny.port'={port},shiny.host='{host}');{read.dcf(path)[1]}::run_app()\""
    )
  )
  dock$write(output)
  alert_build(path, output)
  
}

#' @export
#' @rdname dockerfiles
add_dockerfile_shinyproxy <- function( 
  path = "DESCRIPTION", 
  output = "Dockerfile", 
  pkg = get_golem_wd(), 
  from = paste0(
    "rocker/r-ver:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL,
  sysreqs = TRUE,
  repos = "https://cran.rstudio.com/",
  expand = FALSE
){
  
  where <- file.path(pkg, output)
  
  if ( !check_file_exist(where) ) return(invisible(FALSE))
  usethis::use_build_ignore(basename(where))
  dock <- dock_from_desc(path = path, FROM = from, AS = as, 
                         sysreqs = sysreqs, repos = repos, expand = expand)
  
  dock$EXPOSE(3838)
  dock$CMD(glue::glue(
    " [\"R\", \"-e\", \"options('shiny.port'=3838,shiny.host='0.0.0.0'); {read.dcf(path)[1]}::run_app()\"]"
  ))
  dock$write(output)
  
  alert_build(path, output)
  
  usethis::use_build_ignore(files = output)
  
  invisible(output)
  
}

#' @export
#' @rdname dockerfiles
add_dockerfile_heroku <- function( 
  path = "DESCRIPTION", 
  output = "Dockerfile", 
  pkg = get_golem_wd(), 
  from = paste0(
    "rocker/r-ver:", 
    R.Version()$major,".", 
    R.Version()$minor
  ), 
  as = NULL,
  sysreqs = TRUE,
  repos = "https://cran.rstudio.com/",
  expand = FALSE
){
  where <- file.path(pkg, output)
  
  if ( !check_file_exist(where) ) {
    return(invisible(FALSE))
  } 
  usethis::use_build_ignore(basename(where))
  dock <- dock_from_desc(path = path, FROM = from, AS = as, sysreqs = sysreqs, repos = repos, expand = expand)
  
  dock$CMD(
    glue::glue(
      "R -e \"options('shiny.port'=$PORT,shiny.host='0.0.0.0');{read.dcf(path)[1]}::run_app()\""
    )
  )
  dock$write(output)
  
  alert_build(path, output)
  
  apps_h <- gsub(
    "\\.", "-", 
    glue("{read.dcf(path)[1]}-{read.dcf(path)[1,][['Version']]}")
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

alert_build <- function(path, output){
  cat_green_tick(
    glue("Dockerfile created at {output}")
  )
  cat_red_bullet(
    glue::glue(
      "Be sure to put your {read.dcf(path)[1]}_{read.dcf(path)[1,][['Version']]}.tar.gz file (generated using `devtools::build()` ) in the same folder as the {basename(output)} file generated"
    )
  )
}

#' Create Dockerfile from DESCRIPTION
#
#' @param path path to the DESCRIPTION file to use as an input.
#'
#' @param FROM The FROM of the Dockerfile. Default is FROM rocker/r-ver:
#'     with `R.Version()$major` and `R.Version()$minor`.
#' @param AS The AS of the Dockerfile. Default it NULL.
#' @param sysreqs boolean to check the system requirements    
#' @param repos character vector, the base URL of the repositories  
#' @param expand boolean, if `TRUE` each system requirement will be known his own RUN line
#'
#' @importFrom utils installed.packages packageVersion
#' @importFrom remotes dev_package_deps
#' @importFrom desc desc_get_deps
#' @importFrom magrittr %>% 
#' @importFrom stats setNames
#' 
dock_from_desc <- function(
  path = "DESCRIPTION",
  FROM = paste0(
    "rocker/r-ver:", 
    R.Version()$major,".", 
    R.Version()$minor
  ),
  AS = NULL,
  sysreqs = TRUE,
  repos = "https://cran.rstudio.com/",
  expand = FALSE
){
  
 
  packages <- desc::desc_get_deps(path)$package
  packages <- packages[packages != "R"] # remove R
  packages <- packages[ !packages %in% c("base", "boot", "class", "cluster", 
                                         "codetools", "compiler", "datasets", 
                                         "foreign", "graphics", "grDevices", 
                                         "grid", "KernSmooth", "lattice", "MASS", 
                                         "Matrix", "methods", "mgcv", "nlme", 
                                         "nnet", "parallel", "rpart", "spatial", 
                                         "splines", "stats", "stats4", "survival", 
                                         "tcltk", "tools", "utils")] # remove base and recommended

  
  
 
  if (sysreqs){
    # please wait during system requirement calculation
    cat_bullet("Please wait during system requirements calculation...",bullet = "info",bullet_col = "green") # TODO animated version ?
    system_requirement <- unique(get_sysreqs(packages = packages))
    cat_bullet("done",bullet = "tick",bullet_col = "green") # TODO animated version ?
    
  }else{
    system_requirement <- NULL
  }
  
  remotes_deps <- remotes::package_deps(packages)
  packages_on_cran <- remotes_deps$package[remotes_deps$is_cran] %>% 
    intersect(packages)
  
  packages_not_on_cran <- packages %>% 
    setdiff(packages_on_cran)
  
  
  packages_on_cran <- setNames(lapply(packages_on_cran, packageVersion), packages_on_cran)
  
  
  dock <- dockerfiler::Dockerfile$new(FROM = FROM)
  
  if (length(system_requirement)>0){
    
    if ( !expand){
    dock$RUN(paste("apt-get update && apt-get install -y ",paste(system_requirement,collapse = " ")))
    } else{
    dock$RUN("apt-get update" )
      for ( sr in system_requirement){
    dock$RUN(paste("apt-get install -y ",sr))
      }
    }
    
    }
  
  dock$RUN(
    sprintf("echo \"options(repos = c(CRAN = '%s'), download.file.method = 'libcurl')\" >> /usr/local/lib/R/etc/Rprofile.site",repos))
  dock$RUN("R -e 'install.packages(\"remotes\")'")
  
  # We need to be sure install_cran is there
  dock$RUN("R -e 'remotes::install_github(\"r-lib/remotes\", ref = \"97bbf81\")'")
  
  
  if ( length(packages_on_cran>0)){
  ping <- mapply(function(dock, ver, nm){
    res <- dock$RUN(
      sprintf(
        "Rscript -e 'remotes::install_version(\"%s\", version = \"%s\")'", 
        nm, ver
      )
    )
  }, ver = packages_on_cran, nm = names(packages_on_cran), MoreArgs = list(dock = dock))
  }
  
  if ( length(packages_not_on_cran>0)){
    
    # prepare the install_github
    # 
  nn<-  lapply(
    remotes_deps$remote[!remotes_deps$is_cran],
    function(.){      .[c('repo','username','sha')]
    }) %>% do.call(rbind,.) %>% as.data.frame()
    
    # nn <- remotes_deps$remote[!remotes_deps$is_cran]%>%
    #   map_df(~.x[c('repo','username','sha')]) %>% 
    #   mutate(remote = glue::glue("{username}/{repo}@{sha}")) %>% 
    #   pull(remote)
  nn<- glue::glue("{nn$username}/{nn$repo}@{nn$sha}")
    
    pong <- mapply(function(dock, ver, nm){
      res <- dock$RUN(
        sprintf(
          "Rscript -e 'remotes::install_github(\"%s\")'", 
          ver
        )
      )
    }, ver = nn, MoreArgs = list(dock = dock))
    
    
  }
  
  
  
  dock
  
  
  

  
  dock$COPY(
    from = paste0(read.dcf(path)[1], "_*.tar.gz"),
    to = "/app.tar.gz"
  )
  dock$RUN("R -e 'remotes::install_local(\"/app.tar.gz\")'")
  
  dock
}