# For mocking in test
utils_download_file <- function(...){
  utils_download_file(...)
}
#' Use Files
#'
#' These functions download files from external sources and put them inside the `inst/app/www` directory.
#' The `use_internal_` functions will copy internal files, while `use_external_` will try to download them
#' from a remote location.
#'
#' @inheritParams add_module
#' @param url String representation of URL for the file to be downloaded
#' @param path String representation of the local path for the file to be implemented (use_file only)
#' @param dir Path to the dir where the file while be created.
#'
#' @note See `?htmltools::htmlTemplate` and `https://shiny.rstudio.com/articles/templates.html`
#'     for more information about `htmlTemplate`.
#'
#' @export
#' @rdname use_files
#'
#' @return The path to the file, invisibly.
use_external_js_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  if (missing(name)) {
    name <- basename(url)
  }

  check_name_length_is_one(name)

  name <- file_path_sans_ext(name)
  new_file <- sprintf("%s.js", name)

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(url) != "js") {
    cat_red_bullet(
      "File not added (URL must end with .js extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_download()

  utils_download_file(url, where)

  file_created_dance(
    where,
    after_creation_message_js,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE,
    catfun = cat_downloaded
  )
}

#' @export
#' @rdname use_files
use_external_css_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  if (missing(name)) {
    name <- basename(url)
  }

  check_name_length_is_one(name)

  name <- file_path_sans_ext(name)
  new_file <- sprintf("%s.css", name)

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(url) != "css") {
    cat_red_bullet(
      "File not added (URL must end with .css extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_download()

  utils_download_file(url, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE,
    catfun = cat_downloaded
  )
}

#' @export
#' @rdname use_files
use_external_html_template <- function(
  url,
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  new_file <- sprintf(
    "%s.html",
    file_path_sans_ext(name)
  )

  check_name_length_is_one(name)

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(url) != "html") {
    cat_red_bullet(
      "File not added (URL must end with .html extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_download()

  utils_download_file(url, where)

  cat_downloaded(where)

  file_created_dance(
    where,
    after_creation_message_html_template,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE
  )
}

#' @export
#' @rdname use_files
use_external_file <- function(
  url,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  if (missing(name)) {
    name <- basename(url)
  }

  check_name_length_is_one(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    name
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  cat_start_download()

  utils_download_file(url, where)

  cat_downloaded(where)

  file_created_dance(
    where,
    after_creation_message_any_file,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE
  )
}

#' @export
#' @rdname use_files
use_internal_js_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  if (missing(name)) {
    name <- basename(path)
  }

  check_name_length_is_one(name)

  name <- file_path_sans_ext(name)
  new_file <- sprintf("%s.js", name)

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(path) != "js") {
    cat_red_bullet(
      "File not added (URL must end with .js extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_copy()

  fs_file_copy(path, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    catfun = cat_copied
  )
}

#' @export
#' @rdname use_files
use_internal_css_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  if (missing(name)) {
    name <- basename(path)
  }

  check_name_length_is_one(name)

  name <- file_path_sans_ext(name)
  new_file <- sprintf("%s.css", name)

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(path) != "css") {
    cat_red_bullet(
      "File not added (URL must end with .css extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_copy()

  fs_file_copy(path, where)

  file_created_dance(
    where,
    after_creation_message_css,
    pkg,
    dir,
    name,
    open,
    catfun = cat_copied
  )
}

#' @export
#' @rdname use_files
use_internal_html_template <- function(
  path,
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  check_name_length_is_one(name)

  new_file <- sprintf(
    "%s.html",
    file_path_sans_ext(name)
  )

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    new_file
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  if (file_ext(path) != "html") {
    cat_red_bullet(
      "File not added (URL must end with .html extension)"
    )
    return(invisible(FALSE))
  }

  cat_start_copy()

  fs_file_copy(path, where)

  cat_copied(where)

  file_created_dance(
    where,
    after_creation_message_html_template,
    pkg,
    dir,
    name,
    open
  )
}

#' @export
#' @rdname use_files
use_internal_file <- function(
  path,
  name = NULL,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = FALSE,
  dir_create = TRUE
    ) {
  if (missing(name)) {
    name <- basename(path)
  }

  check_name_length_is_one(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- tryCatch(
    create_if_needed(
      dir,
      type = "directory"
    ),
    error = function(e) {
      out <- FALSE
      names(out) <- e[[1]]
      return(out)
    }
  )

  if (isFALSE(dir_created)) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    name
  )

  if (fs_file_exists(where)) {
    cat_exists(where)
    return(invisible(FALSE))
  }

  cat_start_copy()

  fs_file_copy(path, where)

  cat_copied(where)

  file_created_dance(
    where,
    after_creation_message_any_file,
    pkg,
    dir,
    name,
    open,
    open_or_go_to = FALSE
  )
}
