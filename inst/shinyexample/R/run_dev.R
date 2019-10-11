#' golemLaunch
#' 
#' A tools to use run_dev scripts
#'
#' @return methods to manipulate your run_dev
#'
#' @section Methods:
#' \describe{
#'   \item{\code{show_terminal}}{Display the terminal where your application is launched}
#'   \item{\code{stop}}{Stop your app}
#'   \item{\code{get_buffer}}{Get what you have in your terminal}
#'   \item{\code{get_url}}{Get the url of your application}
#'   \item{\code{open_app}}{Open the url of your application}
#'   \item{\code{restart}}{Restart your application}
#'   \item{\code{is_running}}{Test your terminal is still running}
#'  }
#'
#' @importFrom R6 R6Class
#' @importFrom golem get_golem_wd
#' @export

golemLaunch <- R6Class(
  "golemLaunch",
  public = list(
    process = character(0),
    path_to_run_dev = character(0),
    url = character(0),
    initialize = function(run_dev = "run_dev.R",
                          choose = FALSE) {
      path <- get_golem_wd()
      dev <- file.path(path, "dev")
      if (!dir.exists(dev)) {
        stop("You must be inside a package initialize with {golem}")
      }
      if (choose) {
        list_run_dev <- list.files(dev, pattern = "run_dev")
        choice <- menu(list_run_dev, title = "Choose you run_dev:")
        self$path_to_run_dev <- file.path(dev, list_run_dev[choice])
      } else {
        self$path_to_run_dev <- file.path(dev, run_dev)
      }
      
      if (file.exists(self$path_to_run_dev)) {
        command <- paste0("Rscript '", self$path_to_run_dev, "'")
        self$process <- rstudioapi::terminalExecute(
          command,
          show = FALSE
        )
      } else {
        stop("We don't find this run_dev")
      }
      message("
              Waiting to launch the app")
      Sys.sleep(4)
      self$url <- self$get_url()
    },
    show_terminal = function() {
      rstudioapi::terminalActivate(
        self$process
      )
    },
    stop = function() {
      rstudioapi::terminalKill(
        self$process
      )
    },
    get_buffer = function() {
      rstudioapi::terminalBuffer(
        self$process
      )
    },
    get_url = function() {
      get_address <- self$get_buffer()
      url <- get_address[grep("Listening", get_address)]
      url <- gsub(pattern = "Listening on ", replacement = "", x = url)
      url
    },
    open_app = function() {
      browseURL(self$url)
    },
    restart = function() {
      self$stop()
      self$initialize()
      self$show_terminal()
      self$open_app()
    },
    is_running = function() {
      rstudioapi::terminalBusy(
        self$process
      )
    }
  )
)