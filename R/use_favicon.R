#' Add a favicon to your shinyapp
#'
#' @param path Path to your favicon file (.ico or .png)
#' @inheritParams add_module
#' @param method Method to be used for downloading files, 'curl' is default see [utils::download.file()].
#' @rdname favicon
#' @export
#'
#' @importFrom attempt stop_if_not
#'
#' @return Used for side-effects.
#'
#' @examples
#' if (interactive()) {
#'   use_favicon()
#'   use_favicon(path = "path/to/your/favicon.ico")
#' }
use_favicon <- function(
  path,
  pkg = get_golem_wd(),
  method = "curl"
) {
  if (missing(path)) {
    path <- golem_sys(
      "shinyexample/inst/app/www",
      "favicon.ico"
    )
  }

  ext <- file_ext(path)

  stop_if_not(
    ext,
    ~ .x %in% c("png", "ico"),
    "favicon must have .ico or .png extension"
  )


  local <- fs_file_exists(path)

  if (!local) {
    if (getRversion() >= "3.5") {
      try_online <- attempt::attempt(
        curlGetHeaders(path),
        silent = TRUE
      )
      attempt::stop_if(
        try_online,
        attempt::is_try_error,
        "Provided path is neither a local path nor a reachable url."
      )

      attempt::stop_if_not(
        attr(try_online, "status"),
        ~ .x == 200,
        "Unable to reach provided url (response code is not 200)."
      )
    }

    destfile <- tempfile(
      fileext = paste0(".", ext),
      pattern = "favicon"
    )

    utils::download.file(
      path,
      destfile,
      method = method
    )
    path <- fs_path_abs(destfile)
  }

  old <- setwd(fs_path_abs(pkg))

  on.exit(setwd(old))

  to <- fs_path(
    fs_path_abs(pkg),
    "inst/app/www",
    sprintf(
      "favicon.%s",
      ext
    )
  )

  if (!(path == to)) {
    fs_file_copy(
      path,
      to,
      overwrite = TRUE
    )
    cat_green_tick(
      sprintf(
        "favicon.%s created at %s",
        ext,
        to
      )
    )
  }

  if (ext == "png") {
    cat_red_bullet(
      "You choose a png favicon, please add `ext = 'png'` to `favicon()` within the `golem_add_external_resources()` function in 'app_ui.R'."
    )
  } else {
    cli_cat_line(
      "Favicon is automatically linked in app_ui via `golem_add_external_resources()`"
    )
  }
}

#' @rdname favicon
#' @export
remove_favicon <- function(path = "inst/app/www/favicon.ico") {
  if (fs_file_exists(path)) {
    cat_green_tick(
      sprintf(
        "Removing favicon at %s",
        path
      )
    )
    fs_file_delete(path)
  } else {
    cat_red_bullet(
      sprintf(
        "No file found at %s",
        path
      )
    )
  }
}

#' Add favicon to your app
#'
#' This function adds the favicon from `ico` to your shiny app.
#'
#' @param ico path to favicon file
#' @param rel rel
#' @param resources_path prefix of the resource path of the app
#' @param ext the extension of the favicon
#'
#' @export
#' @importFrom shiny tags
#'
#' @return An HTML tag.
favicon <- function(
  ico = "favicon",
  rel = "shortcut icon",
  resources_path = "www",
  ext = "ico"
) {
  ico <- fs_path(
    resources_path,
    ico,
    ext = ext
  )

  tags$head(
    tags$link(
      rel = rel,
      href = ico
    )
  )
}
