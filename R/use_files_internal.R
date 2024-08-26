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

  copy_internal_file(path, where)

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

  copy_internal_file(path, where)

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

  copy_internal_file(path, where)

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

  copy_internal_file(path, where)

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
