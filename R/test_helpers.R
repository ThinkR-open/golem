#' Test helpers
#' 
#' These functions are designed to be used inside the tests 
#' in your Shiny app package.
#'
#' @param object the object to test
#'
#' @return A testthat result
#' @export
#' @rdname testhelpers
#' 
#' @importFrom testthat quasi_label expect
#' @importFrom rlang enquo
#'
#' @examples
#' expect_shinytag(shiny::tags$span("1"))
expect_shinytag <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    "shiny.tag" %in% act$class,
    sprintf("%s has class %s, not class 'shiny.tag'.", act$lab, paste(act$class, collapse = ", "))
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @importFrom testthat quasi_label expect
#' @importFrom rlang enquo
#' @examples
#' expect_shinytaglist(shiny::tagList(1))
expect_shinytaglist <- function(object) {
  act <- quasi_label(enquo(object), arg = "object")
  act$class <- class(object)
  expect(
    "shiny.tag.list" %in% act$class,
    sprintf("%s has class '%s', not class 'shiny.tag.list'.", act$lab, paste(act$class, collapse = ", "))
  )
  invisible(act$val)
}

#' @export
#' @rdname testhelpers
#' @param ui output of an UI function
#' @param html html file to compare to ui 
#' @importFrom htmltools save_html
#' @importFrom attempt stop_if_not
#' @importFrom testthat expect_equal quasi_label expect
#' @importFrom rlang enquo
expect_html_equal <- function(ui, html){
  stop_if_not(html, file.exists, "Unable to find html file")
  tmp <- tempfile(fileext = ".html")
  save_html(ui, tmp)
  expect_equal(
    readLines(tmp),
    readLines(html), 
    label = "ui",  
    expected.label = "html document" 
  )
}

#' @export
#' @rdname testhelpers
#' @param sleep number of seconds
#' @importFrom testthat skip_on_cran expect_true
#' @importFrom testthat skip_if_not
expect_running <- function(sleep){
  
  skip_on_cran()
  
  # Ok for now we'll get back to this
  skip_if_not(interactive())
  
  # Oh boy using testthat and processx is a mess
  # 
  # We want to launch the app in a background process, 
  # but we don't have access to the same stuff depending on
  # where we call the tests
  # 
  # + We can launch with pkgload::load_all(), but __only__ if the 
  #   current wd is the same as the golem wd
  # + We can launch with library(lib = ) but __only__ if we are in the 
  #   non interactive testthat environment, __where the current package
  #   has been installed in a temporary library__
  # 
  # There are six ways to call tests: 
  # 
  # - (1) Running the test interactively (i.e cmd A + cmd Enter): 
  #   + We're in interactive mode
  #   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG")
  #   + The libPath is the default one
  #   + the wd is the golem path 
  #   + We can use pkgload::load_all()
  #   
  # - (2) Running the test inside the console, with devtools::test()
  #   + We're in interactive mode
  #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
  #   + The libPath is the default one
  #   + the wd is the golem path 
  #   + We can use pkgload::load_all()
  #   
  # - (3) Running the test inside the console, with devtools::check()
  #   + We're not interactive mode
  #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
  #   + the wd is a temp dir
  #   + The libPath is a temp one
  #   + We can't use pkgload
  #   + We can library()
  #   
  # - (4) Clicking on the "Run Tests" button on test file File
  #   + We're not in interactive mode
  #   + We're not in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
  #   + the wd is the golem path 
  #   + We can use pkgload
  #   
  # - (5) Clicking on the "Test" button in RStudio Build Pane
  #   + We're not in interactive mode
  #   + We're not in testthat so no Sys.getenv("TESTTHAT_PKG" )
  #   + the wd is the golem path 
  #   + We can use pkgload
  #   This one is actually the tricky one: we need to detect that we 
  #   are in testthat but non interactively, and inside the golem wd. 
  #   
  # - (6) Clicking on the "Check" button in RStudio Build Pane
  #   + We're not interactive mode
  #   + We're in testthat so there is a Sys.getenv("TESTTHAT_PKG" )
  #   + the wd is a temp dir
  #   + The libPath is a temp one 
  #   + We can't use pkgload
  #   + We can library()
  #   
  #   So two sum up, two times where we can do library(): is when 
  #   we're not in an child process launched
  
  if (Sys.getenv("CALLR_CHILD_R_LIBS_USER" ) == "") {
    pkg_name <- pkgload::pkg_name()
    # We are not in RCMDCHECK
    go_for_pkgload <- TRUE
  } else {
    pkg_name <- Sys.getenv("TESTTHAT_PKG" )
    go_for_pkgload <- FALSE
  }
  
  if (go_for_pkgload){
    # Using pkgload because we can
    shinyproc <- processx::process$new(
      command = normalizePath(file.path(Sys.getenv("R_HOME"),'R')),
      c(
        "-e",
        "pkgload::load_all(here::here());run_app()"
      )
    )
  } else {
    # Using the temps libPaths because we can
    shinyproc <- processx::process$new(
      echo_cmd = TRUE,
      command = normalizePath(file.path(Sys.getenv("R_HOME"),'R')),
      c(
        "-e",
        sprintf("library(%s, lib = '%s');run_app()", pkg_name, .libPaths())
      ), 
      stdout = "|", stderr = "|"
    )
  }
  
  Sys.sleep(sleep)
  expect_true(shinyproc$is_alive())
  shinyproc$kill()
  
  
}