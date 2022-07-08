add_dockerfile_with_renv_ <- function(
  source_folder = ".",
  lockfile = NULL,
  output_dir = fs::path(tempdir(), "deploy"),
  distro = "focal",
  FROM = "rocker/verse",
  AS = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  extra_sysreqs = NULL,
  update_tar_gz = TRUE
  # build_golem_from_source = TRUE,
  
){
  check_is_installed("renv")
  check_is_installed("dockerfiler")
  required_version("dockerfiler", "0.2.0")
  check_is_installed("attachment")
  dir.create(output_dir)
  if ( is.null(lockfile)){
    lockfile <-attachment::create_renv_for_prod(path = source_folder,output = file.path(output_dir,"renv.lock.prod"))
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
  my_dock$COPY("renv.lock.prod","renv.lock")
  my_dock$RUN("R -e 'renv::restore()'")
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



#' @param source_folder path to the Package/golem source folder to deploy. 
#' default is current folder '.'
#' @param lockfile path to the renv.lock file to use. default is `NULL` 
#' @param output_dir folder to export everything deployment related.
#' @param distro One of "focal", "bionic", "xenial", "centos7", or "centos8". 
#' See available distributions at https://hub.docker.com/r/rstudio/r-base/.






#' @inheritParams add_dockerfile
#' @rdname dockerfiles
#' @export
add_dockerfile_with_renv <- function( source_folder = ".",
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
    source_folder = source_folder,
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
  
  base_dock$EXPOSE(port)
  base_dock$CMD(sprintf(
    "R -e \"options('shiny.port'=%s,shiny.host='%s');%s::run_app()\"",
    port,
    host,
    golem::get_golem_name()
  ))
  base_dock
  base_dock$write(as = file.path(output_dir, "Dockerfile"))
  
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
      try(file.edit(file.path(output_dir,"README")))
    } else {
      try(file.edit(file.path(output_dir,"README")))
    }
  }
  
}

#' @inheritParams add_dockerfile
#' @rdname dockerfiles
#' @export
#' @export
add_dockerfile_with_renv_shinyproxy <- function(source_folder = ".",
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
    source_folder = source_folder,
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
