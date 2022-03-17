add_dockerfile_with_renv_ <- function(
  path = ".",
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  FROM = "rocker/verse",
  AS = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  open = TRUE,
  update_tar_gz = TRUE
  # build_golem_from_source = TRUE,
  
){
  check_is_installed("renv")
  check_is_installed("dockerfiler")
  required_version("dockerfiler", "0.1.5.0001")
  check_is_installed("attachment")
  dir.create(output_dir)
  if ( is.null(lockfile)){
    lockfile <-attachment::create_renv_for_prod(path = path,output = file.path(output_dir,"renv.lock.prod"))
  }
  
  file.copy(from = lockfile,to = output_dir)
  socle <- dockerfiler::dock_from_renv(lockfile = lockfile,
                                       distro = distro,
                                       FROM = FROM,repos = repos,
                                       AS = AS,
                                       sysreqs = sysreqs,expand = expand,
                                       extra_sysreqs = extra_sysreqs
  )
  socle$write(as = file.path(output_dir, "Dockerfile_socle"))
  
  
  
  my_dock <- dockerfiler::Dockerfile$new(FROM = paste0(golem::get_golem_name(),"_socle"))
  my_dock$RUN(dockerfiler::r(renv::restore()))
  
  # if (!build_from_source) {
  if (update_tar_gz) {
    old_version <- list.files(path = output_dir,pattern = paste0(golem::get_golem_name(), "_*.*.tar.gz"),full.names = TRUE)
    # file.remove(old_version)
    if (length(old_version) > 0) {
      lapply(old_version, file.remove)
      lapply(old_version, unlink, force = TRUE)
      cat_red_bullet(
        sprintf(
          "%s were removed from folder",
          paste(
            old_version,
            collapse = ", "
          )
        )
      )
    }
    
    
    if (
      isTRUE(
        requireNamespace(
          "pkgbuild",
          quietly = TRUE
        )
      )
    ) {
      out <- pkgbuild::build(
        path = ".",
        dest_path = output_dir,
        vignettes = FALSE
      )
      if (missing(out)) {
        cat_red_bullet("Error during tar.gz building")
      } else {
        use_build_ignore(files = out)
        cat_green_tick(
          sprintf(
            " %s created.",
            out
          )
        )
      }
    } else {
      stop("please install {pkgbuild}")
    }
  }
  # we use an already built tar.gz file
  
  my_dock$COPY(
    from =
                paste0(golem::get_golem_name(), "_*.tar.gz")
      ,
    to = "/app.tar.gz")
  my_dock$RUN("R -e 'remotes::install_local(\"/app.tar.gz\",upgrade=\"never\")'")
  my_dock$RUN("rm /app.tar.gz")
  my_dock
}



#' @param path path to the Package/golem source folder to deploy.
#' @param lockfile path to the renv.lock file to use. default is `NULL` 
#' @param output_dir folder to export everything deployment related.
#' @param from The FROM of the Dockerfile. Default is
#'     FROM rocker/r-ver:`R.Version()$major`.`R.Version()$minor`.
#' @param as The AS of the Dockerfile. Default it NULL.
#' @param port The `options('shiny.port')` on which to run the App.
#'     Default is 80.
#' @param host The `options('shiny.host')` on which to run the App.
#'    Default is 0.0.0.0.
#' @param sysreqs boolean. If TRUE, the Dockerfile will contain sysreq installation.
#' @param repos character. The URL(s) of the repositories to use for `options("repos")`.
#' @param expand boolean. If `TRUE` each system requirement will have its own `RUN` line.
#' @param open boolean. Should the Dockerfile be open after creation? Default is `TRUE`.
#' @param build_golem_from_source boolean. If `TRUE` no tar.gz is created and
#'     the Dockerfile directly mount the source folder.
#' @param update_tar_gz boolean. If `TRUE` and `build_golem_from_source` is also `TRUE`,
#'     an updated tar.gz is created.
#' @param extra_sysreqs character vector. Extra debian system requirements.
#'    Will be installed with apt-get install.










#' @param path 
#' @param lockfile 
#' @param output_dir 
#' @param distro 
#' @param FROM 
#' @param AS 
#' @param sysreqs 
#' @param port 
#' @param host 
#' @param repos 
#' @param expand 
#' @param open 
#' @param extra_sysreqs 
#' @param update_tar_gz 
#'
#' @export
add_dockerfile_with_renv <-function( path = ".",
                                     lockfile = NULL,
                                     output_dir = fs::path(tempdir(), "deploy"),
                                     distro = "focal",
                                     from = "rocker/verse",
                                     as = NULL,
                                     sysreqs = TRUE,
                                     port = 80,
                                     host = "0.0.0.0",
                                     repos = c(CRAN = "https://cran.rstudio.com/"),
                                     expand = FALSE,
                                     open = TRUE,
                                     extra_sysreqs = NULL,
                                     
                                     update_tar_gz = TRUE){
  base_dock <-  add_dockerfile_with_renv_(
    path = path,
    lockfile = lockfile,
    output_dir = output_dir,
    distro = distro,
    FROM = from,
    AS = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    extra_sysreqs = extra_sysreqs,
    update_tar_gz = update_tar_gz
  )
  
  
  
  # pour shinyproxy
  base_dock$EXPOSE(port)
  base_dock$CMD(sprintf(
    "R -e \"options('shiny.port'=%s,shiny.host='%s');%s::run_app()\"",
    port,
    host,
    golem::get_golem_name()
  ))
  base_dock
  base_dock$write(as = file.path(output_dir, "Dockerfile"))
  
  
  
  
  
  # out <- glue::glue("docker build -f Dockerfile_socle -t {paste0(golem::get_golem_name(),'_socle')} .
  #          docker build -f Dockerfile -t {paste0(golem::get_golem_name(),':latest')} .
  #          # pour tester en local sur 127.0.0.1:{port}
  #          docker run -v -p {port}:{port} {paste0(golem::get_golem_name(),':latest')}
  #         ")
  
  
  out <- sprintf("docker build -f Dockerfile_socle --progress=plain -t %s .
docker build -f Dockerfile --progress=plain -t %s .
docker run -p %s:%s %s
# then go to 127.0.0.1:%s",paste0(golem::get_golem_name(),'_socle'),
                 paste0(golem::get_golem_name(),':latest'),
                 port,
                 port,
                 paste0(golem::get_golem_name(),':latest'),
                 port
  )
  
  
  
  
  
  cat(out,file = file.path(output_dir, "README"))
  
  if (open) {
    if (rstudioapi::isAvailable() & rstudioapi::hasFun("navigateToFile")) {
      rstudioapi::filesPaneNavigate(output_dir)
    } else {
      try(file.edit(file.path(output_dir,"README")))
    }
  }
  
}

#' @param path 
#'
#' @param lockfile 
#' @param output_dir 
#' @param distro 
#' @param FROM 
#' @param AS 
#' @param sysreqs 
#' @param repos 
#' @param expand 
#' @param extra_sysreqs 
#' @param open 
#' @param update_tar_gz 
#'
#' @export
add_dockerfile_with_renv_shinyproxy <- function(path = ".",
                                                lockfile = NULL,
                                                output_dir = fs::path(tempdir(), "deploy"),
                                                distro = "focal",
                                                from = "rocker/verse",
                                                as = NULL,
                                                sysreqs = TRUE,
                                                repos = c(CRAN = "https://cran.rstudio.com/"),
                                                expand = FALSE,
                                                extra_sysreqs = NULL,
                                                open = TRUE,
                                                update_tar_gz = TRUE) {
  add_dockerfile_with_renv(
    path = path,
    lockfile = lockfile,
    output_dir = output_dir,
    distro = distro,
    from = from,
    as = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    port = 3838,
    host = "0.0.0.0",
    extra_sysreqs = extra_sysreqs,
    update_tar_gz = update_tar_gz,
    open = open
  )
  
  
}
