#' loops env for autoreload
loops <- new.env()


#' Run run_dev.R
#'
#' @param file File path to `run_dev.R`. Defaults to `dev/run_dev.R`.
#' @param pkg Package name to run the file. Defaults to current active package.
#' @param autoreload by default FALSE. If TRUE, it will reload app for changment.
#' 
#' @details Allows to mimic the operation of options(shiny.autoreload = TRUE) if autoreload is TRUE. To stop the autoreload, you have to use golem::stop_autoreload() or restart the R session.
#' 
#' @export
#' 
#' @return Used for side-effect
run_dev <- function(
  file, 
  pkg = pkgload::pkg_name(),
  autoreload = FALSE
){
  if (missing(file)) { 
    file <- "dev/run_dev.R"
  } 
  
  if (pkgload::is_dev_package(pkg)) {
    run_dev_lines <- readLines(
      file.path(
        pkgload::pkg_path(), 
        file
      )
    )
    
  } else {
    try_dev <- file.path(
      pkgload::pkg_path(),
      file
    )
    
    if ( file.exists(try_dev) ) {
      run_dev_lines <- readLines(file)
      
    } else {
      stop("Unable to locate dev file")
    }
  }
  if(autoreload){
    if (!requireNamespace("R6")){
      stop("Please install the {R6} package to run autoreload.")
    }
    loops$autoreload <- golemLaunch$new(file = file)
    cli::cli_text("For advanced use, assign the result of this function")
    invisible(loops$autoreload)
  }else{
    eval(parse(text = run_dev_lines))
  }
}

#' Stop autoreload
#' @export
stop_autoreload <- function(){
  loops$autoreload$stop_autoreload()
}

#' golemLaunch
#' 
#' A tools to use run_dev scripts
#'
#' @return methods to manipulate your run_dev
#'

golemLaunch <- R6::R6Class(
  "golemLaunch",
  public = list(
    #' @field process name of the process
    process = character(0),
    #' @field dir_of_app app dir
    dir_of_app = character(0),
    #' @field run_dev loop for restart
    run_dev = new.env(),
    #' @field hash hash to now save time of files
    hash = character(0),
    #' @field path_to_run_dev path to the run_dev script
    path_to_run_dev = character(0),
    #' @field file file to run
    file = character(0),
    #' @description
    #' Create new object to interact with the dev app 
    #' @param file path of the script to run
    #' @param path path to the app folder initialize with golem, by default get_golem_wd
    #'
    #' @return object to interact with dev app
    initialize = function(file = "dev/run_dev.R",
                          path = golem::get_golem_wd()) {
      dev <- file.path(path, "dev")
      self$dir_of_app <- path
      self$file <- file
      if (!dir.exists(dev)) {
        stop("You must be inside a package initialize with {golem}")
      }

      self$path_to_run_dev <- file.path(self$dir_of_app, file)
      
      if (file.exists(self$path_to_run_dev)) {
        self$auto_reload()
      } else {
        stop("We don't find this file")
      }
    },
    #' @description
    #' Start the app
    #'
    start = function() {
      if (!requireNamespace("processx")){
        stop("Please install the {processx} package to run autoreload.")
      }
      self$process <- processx::process$new(
        stderr = "",
        stdout = "",
        wd = self$dir_of_app,
        supervise = TRUE,
        "Rscript", c( 
          "-e",
          glue::glue("options(shiny.launch.browser=TRUE);golem::run_dev(file = '{self$file}', autoreload = FALSE)")
        )
      )
    },
    #' @description
    #' Stop the app
    #'
    stop = function() {
      self$process$kill()
    },
    #' @description
    #' Restart the app
    #' 
    restart = function() {
      cli::cli_alert_warning("Stopping app")
      self$stop()
      cli::cli_alert_info("Please wait, stating the new app")
      self$start()
    },
    #' @description
    #' Find if the process of the app is running
    #'
    is_running = function() {
      self$process$is_alive()
    },
    #' @description
    #' Auto reload shiny app develop with {golem}
    #'
    auto_reload = function() { 
      if (!requireNamespace("later")){
        stop("Please install the {later} package to run autoreload.")
      }
      self$hash <- get_files(self$dir_of_app)
      self$run_dev <- later::create_loop()
      run_dev_now <- function(){
        new_hash <- get_files(self$dir_of_app)
        if (new_hash != self$hash){
          cli::cat_rule("Relaunching the app")
          self$hash <- new_hash
          self$restart()
        }else if(private$first == 1){
          self$start()
          private$first <- 2
        }
        later::later(
          run_dev_now, 
          1, 
          loop = self$run_dev
        )
      }
      run_dev_now()
    },
    #' @description
    #' Stop auto reload
    #'
    stop_autoreload = function() {
      cli::cli_alert_warning("Stopping app")
      self$stop()
      cli::cli_alert_warning("Cleanning event loop")
      later::destroy_loop(
        self$run_dev
      )
    }
  ),
  private = list(
    # first to initialize app
    first = 1
  )
)

#' Get hash to now if something change
#'
#' @param dirs vector of dirs to check in package
#'
#' @return character string

get_files <- function(dirs){
  if (!requireNamespace("digest")){
    stop("Please install the {digest} package to run autoreload.")
  }
  digest::digest(
    file.info(
      list.files(
        path = dirs,
        recursive = TRUE, 
        full.names = TRUE,
        pattern = "[^NAMESPACE]"
      )
    )[, "mtime"]
  )
}
