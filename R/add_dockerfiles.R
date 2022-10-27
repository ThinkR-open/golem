talk_once <- function(.f, msg = "") {
  talk <- TRUE
  function(...) {
    if (talk) {
      talk <<- FALSE
      cat_red_bullet(msg)
    }
    .f(...)
  }
}

#' Create a Dockerfile for your App
#'
#' Build a container containing your Shiny App. `add_dockerfile()` and
#' `add_dockerfile_with_renv()` and `add_dockerfile_with_renv()` creates
#' a generic Dockerfile, while `add_dockerfile_shinyproxy()`,
#' `add_dockerfile_with_renv_shinyproxy()` , `add_dockerfile_with_renv_shinyproxy()` and
#' `add_dockerfile_heroku()` creates platform specific Dockerfile.
#'
#' @inheritParams add_module
#'
#' @param path path to the DESCRIPTION file to use as an input.
#' @param output name of the Dockerfile output.
#' @param from The FROM of the Dockerfile. Default is
#'
#'     FROM rocker/verse
#'
#'     without renv.lock file passed
#'     `R.Version()$major`.`R.Version()$minor` is used as tag
#'
#' @param as The AS of the Dockerfile. Default it NULL.
#' @param port The `options('shiny.port')` on which to run the App.
#'     Default is 80.
#' @param host The `options('shiny.host')` on which to run the App.
#'    Default is 0.0.0.0.
#' @param sysreqs boolean. If TRUE, RUN statements to install packages
#' system requirements will be included in the Dockerfile.
#' @param repos character. The URL(s) of the repositories to use for `options("repos")`.
#' @param expand boolean. If `TRUE` each system requirement will have its own `RUN` line.
#' @param open boolean. Should the Dockerfile/README/README be open after creation? Default is `TRUE`.
#' @param build_golem_from_source boolean. If `TRUE` no tar.gz is created and
#'     the Dockerfile directly mount the source folder.
#' @param update_tar_gz boolean. If `TRUE` and `build_golem_from_source` is also `TRUE`,
#'     an updated tar.gz is created.
#' @param extra_sysreqs character vector. Extra debian system requirements.
#'
#' @export
#' @rdname dockerfiles
#'
#' @importFrom desc desc_get_deps
#' @importFrom rstudioapi navigateToFile isAvailable hasFun
#'
#' @examples
#' \donttest{
#' # Add a standard Dockerfile
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile()
#' }
#' # Crete a 'deploy' folder containing everything needed to deploy
#' # the golem using docker based on {renv}
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile_with_renv(
#'     # lockfile = "renv.lock", # uncomment to use existing renv.lock file
#'     output_dir = "deploy"
#'   )
#' }
#' # Add a Dockerfile for ShinyProxy
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile_shinyproxy()
#' }
#'
#' # Crete a 'deploy' folder containing everything needed to deploy
#' # the golem with ShinyProxy using docker based on {renv}
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile_with_renv(
#'     # lockfile = "renv.lock",# uncomment to use existing renv.lock file
#'     output_dir = "deploy"
#'   )
#' }
#'
#' # Add a Dockerfile for Heroku
#' if (interactive() & requireNamespace("dockerfiler")) {
#'   add_dockerfile_heroku()
#' }
#' }
#' @return The `{dockerfiler}` object, invisibly.
add_dockerfile <- function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  port = 80,
  host = "0.0.0.0",
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
) {
  add_dockerfile_(
    path = path,
    output = output,
    pkg = pkg,
    from = from,
    as = as,
    port = port,
    host = host,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    open = open,
    update_tar_gz = update_tar_gz,
    build_golem_from_source = build_golem_from_source,
    extra_sysreqs = extra_sysreqs
  )
}

add_dockerfile_ <- talk_once(
  function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  port = 80,
  host = "0.0.0.0",
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
  ) {
    where <- fs_path(pkg, output)

    usethis_use_build_ignore(
      basename(where)
    )

    dock <- dockerfiler_dock_from_desc(
      path = path,
      FROM = from,
      AS = as,
      sysreqs = sysreqs,
      repos = repos,
      expand = expand,
      build_from_source = build_golem_from_source,
      update_tar_gz = update_tar_gz,
      extra_sysreqs = extra_sysreqs
    )

    dock$EXPOSE(port)

    dock$CMD(
      sprintf(
        "R -e \"options('shiny.port'=%s,shiny.host='%s');%s::run_app()\"",
        port,
        host,
        read.dcf(path)[1]
      )
    )

    dock$write(output)

    if (open) {
      if (rstudioapi::isAvailable() & rstudioapi::hasFun("navigateToFile")) {
        rstudioapi::navigateToFile(output)
      } else {
        try(file.edit(output))
      }
    }
    alert_build(
      path = path,
      output = output,
      build_golem_from_source = build_golem_from_source
    )

    return(invisible(dock))
  },
  "golem::add_dockerfile() is not recommended anymore.\nPlease use golem::add_dockerfile_with_renv() instead."
)

#' @export
#' @rdname dockerfiles
add_dockerfile_shinyproxy <- function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
) {
  add_dockerfile_shinyproxy_(
    path = path,
    output = output,
    pkg = pkg,
    from = from,
    as = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    open = open,
    update_tar_gz = update_tar_gz,
    build_golem_from_source = build_golem_from_source,
    extra_sysreqs = extra_sysreqs
  )
}

add_dockerfile_shinyproxy_ <- talk_once(
  function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
  ) {
    where <- fs_path(pkg, output)

    usethis_use_build_ignore(output)

    dock <- dockerfiler_dock_from_desc(
      path = path,
      FROM = from,
      AS = as,
      sysreqs = sysreqs,
      repos = repos,
      expand = expand,
      build_from_source = build_golem_from_source,
      update_tar_gz = update_tar_gz,
      extra_sysreqs = extra_sysreqs
    )

    dock$EXPOSE(3838)
    dock$CMD(sprintf(
      " [\"R\", \"-e\", \"options('shiny.port'=3838,shiny.host='0.0.0.0');%s::run_app()\"]",
      read.dcf(path)[1]
    ))
    dock$write(output)

    if (open) {
      if (rstudioapi::isAvailable() & rstudioapi::hasFun("navigateToFile")) {
        rstudioapi::navigateToFile(output)
      } else {
        try(file.edit(output))
      }
    }
    alert_build(
      path,
      output,
      build_golem_from_source = build_golem_from_source
    )

    return(invisible(dock))
  },
  "golem::add_dockerfile_shinyproxy() is not recommended anymore.\nPlease use golem::add_dockerfile_with_renv_shinyproxy() instead."
)

#' @export
#' @rdname dockerfiles
add_dockerfile_heroku <- function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
) {
  add_dockerfile_heroku_(
    path = path,
    output = output,
    pkg = pkg,
    from = from,
    as = as,
    sysreqs = sysreqs,
    repos = repos,
    expand = expand,
    open = open,
    update_tar_gz = update_tar_gz,
    build_golem_from_source = build_golem_from_source,
    extra_sysreqs = extra_sysreqs
  )
}

add_dockerfile_heroku_ <- talk_once(
  function(
  path = "DESCRIPTION",
  output = "Dockerfile",
  pkg = get_golem_wd(),
  from = paste0(
    "rocker/verse:",
    R.Version()$major,
    ".",
    R.Version()$minor
  ),
  as = NULL,
  sysreqs = TRUE,
  repos = c(CRAN = "https://cran.rstudio.com/"),
  expand = FALSE,
  open = TRUE,
  update_tar_gz = TRUE,
  build_golem_from_source = TRUE,
  extra_sysreqs = NULL
  ) {
    where <- fs_path(pkg, output)

    usethis_use_build_ignore(output)

    dock <- dockerfiler_dock_from_desc(
      path = path,
      FROM = from,
      AS = as,
      sysreqs = sysreqs,
      repos = repos,
      expand = expand,
      build_from_source = build_golem_from_source,
      update_tar_gz = update_tar_gz,
      extra_sysreqs = extra_sysreqs
    )

    dock$CMD(
      sprintf(
        "R -e \"options('shiny.port'=$PORT,shiny.host='0.0.0.0');%s::run_app()\"",
        read.dcf(path)[1]
      )
    )
    dock$write(output)

    alert_build(
      path = path,
      output = output,
      build_golem_from_source = build_golem_from_source
    )

    apps_h <- gsub(
      "\\.",
      "-",
      sprintf(
        "%s-%s",
        read.dcf(path)[1],
        read.dcf(path)[1, ][["Version"]]
      )
    )

    cat_rule("From your command line, run:")
    cat_line("heroku container:login")
    cat_line(
      sprintf("heroku create %s", apps_h)
    )
    cat_line(
      sprintf("heroku container:push web --app %s", apps_h)
    )
    cat_line(
      sprintf("heroku container:release web --app %s", apps_h)
    )
    cat_line(
      sprintf("heroku open --app %s", apps_h)
    )
    cat_red_bullet("Be sure to have the heroku CLI installed.")
    cat_red_bullet(
      sprintf("You can replace %s with another app name.", apps_h)
    )
    if (open) {
      if (rstudioapi::isAvailable() & rstudioapi::hasFun("navigateToFile")) {
        rstudioapi::navigateToFile(output)
      } else {
        try(file.edit(output))
      }
    }
    usethis_use_build_ignore(files = output)
    return(invisible(dock))
  },
  "
golem::add_dockerfile_heroku() is not recommended anymore.\nPlease use golem::add_dockerfile_with_renv_heroku() instead.
"
)

alert_build <- function(
  path,
  output,
  build_golem_from_source
) {
  cat_created(output, "Dockerfile")
  if (!build_golem_from_source) {
    cat_red_bullet(
      sprintf(
        "Be sure to keep your %s_%s.tar.gz file (generated using `pkgbuild::build(vignettes = FALSE)` ) in the same folder as the %s file generated",
        read.dcf(path)[1],
        read.dcf(path)[1, ][["Version"]],
        basename(output)
      )
    )
  }
}
