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
    update_tar_gz = TRUE,
    document = FALSE,
    ...
    # build_golem_from_source = TRUE,
    ) {
  if (is.null(lockfile)) {
    rlang::check_installed(
      c("renv", "attachment"),
      reason = "to build a Dockerfile with automatic renv.lock creation. Use the `lockfile` parameter to pass your own `renv.lock` file."
    )
  }


  # Small hack to prevent warning from rlang::lang() in tests
  # This should be managed in {attempt} later on
  x <- suppressWarnings({
    rlang::lang(print)
  })

  dir.create(output_dir)

  # add output_dir in Rbuildignore if the output is inside the golem
  if (normalizePath(dirname(output_dir)) == normalizePath(source_folder)) {
    usethis_use_build_ignore(output_dir)
  }

  if (is.null(lockfile)) {
    if (isTRUE(document)) {
      cli_cat_line("You set `document = TRUE` and you did not pass your own renv.lock file,")
      cli_cat_line("as a consequence {golem} will use `attachment::att_amend_desc()` to update your ")
      cli_cat_line("DESCRIPTION file before creating the renv.lock file")
      cli_cat_line("")
      cli_cat_line("you can set `document = FALSE` to use your actual DESCRIPTION file,")
      cli_cat_line("or pass you own renv.lock to use, using the `lockfile` parameter")
      cli_cat_line("")
      cli_cat_line("In any case be sure to have no Error or Warning at `devtools::check()`")
    }




    lockfile <- attachment_create_renv_for_prod(
      path = source_folder,
      check_if_suggests_is_installed = FALSE, document = document,
      output = file.path(output_dir, "renv.lock.prod"),
      ...
    )
  }

  # fs_file_copy(
  #   path = lockfile,
  #   new_path = output_dir,
  #   overwrite = TRUE
  # )
  file.copy(from = lockfile, to = output_dir)
  socle <- dockerfiler::dock_from_renv(
    lockfile = lockfile,
    distro = distro,
    FROM = FROM,
    repos = repos,
    AS = AS,
    sysreqs = sysreqs,
    expand = expand,
    extra_sysreqs = extra_sysreqs
  )

  socle$write(as = file.path(output_dir, "Dockerfile_base"))


  my_dock <- dockerfiler_Dockerfile()$new(FROM = tolower(tolower(paste0(golem::get_golem_name(), "_base"))))

  my_dock$COPY("renv.lock.prod", "renv.lock")

  my_dock$RUN("R -e 'renv::restore()'")

  if (update_tar_gz) {
    old_version <- list.files(path = output_dir, pattern = paste0(golem::get_golem_name(), "_*.*.tar.gz"), full.names = TRUE)
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
      paste0(golem::get_golem_name(), "_*.tar.gz"),
    to = "/app.tar.gz"
  )
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
#' @param document boolean. If TRUE (by default), DESCRIPTION file is updated using [attachment::att_amend_desc()] before creating the renv.lock file
#' @param dockerfile_cmd What is the CMD to add to the Dockerfile. If NULL, the default,
#' the CMD will be `R -e "options('shiny.port'={port},shiny.host='{host}');library({appname});{appname}::run_app()\`
#' @param ... Other arguments to pass to [renv::snapshot()]
#' @inheritParams add_dockerfile
#' @rdname dockerfiles
#' @export
add_dockerfile_with_renv <- function(
    source_folder = ".",
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
    document = TRUE,
    extra_sysreqs = NULL,
    update_tar_gz = TRUE,
    dockerfile_cmd = NULL,
    ...) {
  base_dock <- add_dockerfile_with_renv_(
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
    update_tar_gz = update_tar_gz,
    document = document,
    ...
  )
  if (!is.null(port)) {
    base_dock$EXPOSE(port)
  }
  if (is.null(dockerfile_cmd)) {
    dockerfile_cmd <- sprintf(
      "R -e \"options('shiny.port'=%s,shiny.host='%s');library(%3$s);%3$s::run_app()\"",
      port,
      host,
      golem::get_golem_name()
    )
  }
  base_dock$CMD(
    dockerfile_cmd
  )
  base_dock
  base_dock$write(as = file.path(output_dir, "Dockerfile"))

  out <- sprintf(
    "docker build -f Dockerfile_base --progress=plain -t %s .
docker build -f Dockerfile --progress=plain -t %s .
docker run -p %s:%s %s
# then go to 127.0.0.1:%s",
    tolower(paste0(golem::get_golem_name(), "_base")),
    tolower(paste0(golem::get_golem_name(), ":latest")),
    port,
    port,
    tolower(paste0(golem::get_golem_name(), ":latest")),
    port
  )

  cat(out, file = file.path(output_dir, "README"))

  open_or_go_to(
    where = file.path(output_dir, "README"),
    open_file = open
  )
}

#' @inheritParams add_dockerfile_with_renv
#' @rdname dockerfiles
#' @export
#' @export
add_dockerfile_with_renv_shinyproxy <- function(
    source_folder = ".",
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
    document = TRUE,
    update_tar_gz = TRUE,
    ...) {
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
    open = open,
    document = document,
    dockerfile_cmd = sprintf(
      "R -e \"options('shiny.port'=3838,shiny.host='0.0.0.0');library(%1$s);%1$s::run_app()\"",
      golem::get_golem_name()
    ),
    ...
  )
}

#' @inheritParams add_dockerfile_with_renv
#' @rdname dockerfiles
#' @export
#' @export
add_dockerfile_with_renv_heroku <- function(
    source_folder = ".",
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
    document = TRUE,
    update_tar_gz = TRUE,
    ...) {
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
    port = NULL,
    host = "0.0.0.0",
    extra_sysreqs = extra_sysreqs,
    update_tar_gz = update_tar_gz,
    open = FALSE,
    document = document,
    dockerfile_cmd = sprintf(
      "R -e \"options('shiny.port'=$PORT,shiny.host='0.0.0.0');library(%1$s);%1$s::run_app()\"",
      golem::get_golem_name()
    ),
    ...
  )

  apps_h <- gsub(
    "\\.",
    "-",
    sprintf(
      "%s-%s",
      golem::get_golem_name(),
      golem::get_golem_version()
    )
  )

  readme_output <- fs_path(
    output_dir,
    "README"
  )

  write_there <- function(...) {
    write(..., file = readme_output, append = TRUE)
  }

  write_there("From your command line, run:\n")

  write_there(
    sprintf(
      "docker build -f Dockerfile_base --progress=plain -t %s .",
      paste0(golem::get_golem_name(), "_base")
    )
  )

  write_there(
    sprintf(
      "docker build -f Dockerfile --progress=plain -t %s .\n",
      paste0(golem::get_golem_name(), ":latest")
    )
  )

  write_there("Then, to push on heroku:\n")

  write_there("heroku container:login")
  write_there(
    sprintf("heroku create %s", apps_h)
  )
  write_there(
    sprintf("heroku container:push web --app %s", apps_h)
  )
  write_there(
    sprintf("heroku container:release web --app %s", apps_h)
  )
  write_there(
    sprintf("heroku open --app %s\n", apps_h)
  )
  write_there("> Be sure to have the heroku CLI installed.")

  write_there(
    sprintf("> You can replace %s with another app name.", apps_h)
  )

  # The open is deported here just to be sure
  # That we open the README once it has been populated
  open_or_go_to(
    where = readme_output,
    open_file = open
  )
}
