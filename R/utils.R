golem_sys <- function(
  ...,
  lib.loc = NULL,
  mustWork = FALSE
    ) {
  system.file(
    ...,
    package = "golem",
    lib.loc = lib.loc,
    mustWork = mustWork
  )
}



create_if_needed <- function(
  path,
  type = c("file", "directory"),
  content = NULL
    ) {
  type <- match.arg(type)

  # Check if file or dir already exist
  if (type == "file") {
    dont_exist <- Negate(fs_file_exists)(path)
  } else if (type == "directory") {
    dont_exist <- Negate(fs_dir_exists)(path)
  }
  # If it doesn't exist, ask if we are allowed to create it
  if (dont_exist) {
    if (rlang::is_interactive()) {
      ask <- ask_golem_creation_file(path, type)
      # Return early if the user doesn't allow
      if (!ask) {
        return(FALSE)
      }
      # Create the file
      if (type == "file") {
        fs_file_create(path)
        write(content, path, append = TRUE)
      } else if (type == "directory") {
        fs_dir_create(path, recurse = TRUE)
      }
    } else {
      stop(
        sprintf(
          "The %s %s doesn't exist.",
          basename(path),
          type
        )
      )
    }
  }
  # TRUE means that file exists (either created or already there)
  return(TRUE)
}
ask_golem_creation_file <- function(path, type) {
  yesno(
    sprintf(
      "The %s %s doesn't exist, create?",
      basename(path),
      type
    )
  )
}

# internal
replace_word <- function(
  file,
  pattern,
  replace
    ) {
  suppressWarnings(tx <- readLines(file))
  tx2 <- gsub(
    pattern = pattern,
    replacement = replace,
    x = tx
  )
  writeLines(
    tx2,
    con = file
  )
}

remove_comments <- function(file) {
  lines <- readLines(file)
  lines_without_comment <- c()
  for (line in lines) {
    lines_without_comment <- append(
      lines_without_comment,
      gsub("(\\s*#+[^'@].*$| #+[^#].*$)", "", line)
    )
  }
  lines_without_comment <- lines_without_comment[lines_without_comment != ""]
  writeLines(text = lines_without_comment, con = file)
}

cat_green_tick <- function(...) {
  do_if_unquiet({
    cli_cat_bullet(
      ...,
      bullet = "tick",
      bullet_col = "green"
    )
  })
}

cat_red_bullet <- function(...) {
  do_if_unquiet({
    cli_cat_bullet(
      ...,
      bullet = "bullet",
      bullet_col = "red"
    )
  })
}

cat_info <- function(...) {
  do_if_unquiet({
    cli_cat_bullet(
      ...,
      bullet = "arrow_right",
      bullet_col = "grey"
    )
  })
}


cat_exists <- function(where) {
  cat_red_bullet(
    sprintf(
      "[Skipped] %s already exists.",
      basename(where)
    )
  )
  cat_info(
    sprintf(
      "If you want replace it, remove the %s file first.",
      basename(where)
    )
  )
}

cat_dir_necessary <- function() {
  cat_red_bullet(
    "File not added (needs a valid directory)"
  )
}

cat_start_download <- function() {
  do_if_unquiet({
    cli_cat_line("")
    cli_cat_line("Initiating file download")
  })
}

cat_downloaded <- function(
  where,
  file = "File"
    ) {
  cat_green_tick(
    sprintf(
      "%s downloaded at %s",
      file,
      where
    )
  )
}

cat_start_copy <- function() {
  do_if_unquiet({
    cli_cat_line("")
    cli_cat_line("Copying file")
  })
}

cat_copied <- function(
  where,
  file = "File"
    ) {
  cat_green_tick(
    sprintf(
      "%s copied to %s",
      file,
      where
    )
  )
}

cat_created <- function(
  where,
  file = "File"
    ) {
  cat_green_tick(
    sprintf(
      "%s created at %s",
      file,
      where
    )
  )
}

# File made dance

cat_automatically_linked <- function() {
  cat_green_tick(
    "File automatically linked in `golem_add_external_resources()`."
  )
}

open_or_go_to <- function(
  where,
  open_file
    ) {
  if (
    open_file
  ) {
    rstudioapi_navigateToFile(where)
  } else {
    cat_red_bullet(
      sprintf(
        "Go to %s",
        where
      )
    )
  }
  invisible(where)
}

desc_exist <- function(pkg) {
  fs_file_exists(
    paste0(pkg, "/DESCRIPTION")
  )
}

after_creation_message_js <- function(
  pkg,
  dir,
  name
    ) {
  if (
    desc_exist(pkg)
  ) {
    if (
      fs_path_abs(dir) != fs_path_abs("inst/app/www") &
        utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'To link to this file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$script(src="www/%s.js")`',
          name
        )
      )
    } else {
      cat_automatically_linked()
    }
  }
}
after_creation_message_css <- function(
  pkg,
  dir,
  name
    ) {
  if (
    desc_exist(pkg)
  ) {
    if (fs_path_abs(dir) != fs_path_abs("inst/app/www") &
      utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'To link to this file,  go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$link(rel="stylesheet", type="text/css", href="www/.css")`',
          name
        )
      )
    } else {
      cat_automatically_linked()
    }
  }
}

after_creation_message_sass <- function(
  pkg,
  dir,
  name
    ) {
  if (
    desc_exist(pkg)
  ) {
    if (fs_path_abs(dir) != fs_path_abs("inst/app/www") &
      utils::packageVersion("golem") < "0.2.0"
    ) {
      cat_red_bullet(
        sprintf(
          'After compile your Sass file, to link your css file, go to the `golem_add_external_resources()` function in `app_ui.R` and add `tags$link(rel="stylesheet", type="text/css", href="www/.css")`'
        )
      )
    }
  }
}

after_creation_message_html_template <- function(
  pkg,
  dir,
  name
    ) {
  do_if_unquiet({
    cli_cat_line("")
    cli_cat_line("To use this html file as a template, add the following code in your UI:")
    cli_cat_line(crayon_darkgrey("htmlTemplate("))
    cli_cat_line(crayon_darkgrey(sprintf('    app_sys("app/www/%s.html"),', file_path_sans_ext(name))))
    cli_cat_line(crayon_darkgrey("    body = tagList()"))
    cli_cat_line(crayon_darkgrey("    # add here other template arguments"))
    cli_cat_line(crayon_darkgrey(")"))
  })
}

file_created_dance <- function(
  where,
  fun,
  pkg,
  dir,
  name,
  open_file,
  open_or_go_to = TRUE,
  catfun = cat_created
    ) {
  catfun(where)

  fun(pkg, dir, name)

  if (open_or_go_to) {
    open_or_go_to(
      where = where,
      open_file = open_file
    )
  } else {
    return(invisible(where))
  }
}

file_already_there_dance <- function(
  where,
  open_file
    ) {
  cat_green_tick("File already exists.")
  open_or_go_to(
    where = where,
    open_file = open_file
  )
}
# Minor toolings

if_not_null <- function(x, ...) {
  if (!is.null(x)) {
    force(...)
  }
}

set_name <- function(x, y) {
  names(x) <- y
  x
}

# FROM tools::file_path_sans_ext() & tools::file_ext
file_path_sans_ext <- function(x) {
  sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
}

file_ext <- function(x) {
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  ifelse(pos > -1L, substring(x, pos + 1L), "")
}

#' @importFrom utils menu
yesno <- function(...) {
  cat(paste0(..., collapse = ""))
  menu(c("Yes", "No")) == 1
}


# Checking that a package is installed
check_is_installed <- function(
  pak,
  ...
    ) {
  if (
    !requireNamespace(pak, ..., quietly = TRUE)
  ) {
    stop(
      sprintf(
        "The {%s} package is required to run this function.\nYou can install it with `install.packages('%s')`.",
        pak,
        pak
      ),
      call. = FALSE
    )
  }
}

required_version <- function(
  pak,
  version
    ) {
  if (
    utils::packageVersion(pak) < version
  ) {
    stop(
      sprintf(
        "This function require the version '%s' of the {%s} package.\nYou can update with `install.packages('%s')`.",
        version,
        pak,
        pak
      ),
      call. = FALSE
    )
  }
}




add_sass_code <- function(where, dir, name) {
  if (fs_file_exists(where)) {
    if (fs_file_exists("dev/run_dev.R")) {
      lines <- readLines("dev/run_dev.R")
      new_lines <- append(
        x = lines,
        values = c(
          "# Sass code compilation",
          sprintf(
            'sass::sass(input = sass::sass_file("%s/%s.sass"), output = "%s/%s.css", cache = NULL)',
            dir,
            name,
            dir,
            name
          ),
          ""
        ),
        after = 0
      )
      writeLines(
        text = new_lines,
        con = "dev/run_dev.R"
      )

      cat_green_tick(
        "Code added in run_dev.R to compile your Sass file to CSS file."
      )
    }
  }
}

#' Check if a module (`R`-file) already exists
#'
#' Should be called at the root of a `{golem}` project; but an error is thrown
#' only if one is not inside an R package (as the checks of `golem:::is_golem()`
#' are rather strict, specifically only the presence of a "R/" directory is
#' checked for the moment).
#'
#' @param module a character string giving the name of a potentially existing
#'    module `R`-file
#' @return boolean; `TRUE` if the module (`R`-file) exists and `FALSE` else
#' @noRd
is_existing_module <- function(module) {
  stopifnot(`Cannot be called when not inside a R-package` = dir.exists("R"))
  # stopifnot(`Cannot be called when not inside a golem-project` = is.golem())
  existing_module_files <- list.files("R/", pattern = "^mod_")
  existing_module_names <- sub(
    "^mod_([[:alnum:]_]+)\\.R$",
    "\\1",
    existing_module_files
  )
  module %in% existing_module_names
}

# This function is used for checking
# that  the name argument of the function
# creating files is not of length() > 1
check_name_length <- function(name) {
  stop_if(
    name,
    ~ length(.x) > 1,
    sprintf(
      "`name` should be of length 1. Got %d.",
      length(name)
    )
  )
}

do_if_unquiet <- function(expr) {
  if (
    !getOption(
      "golem.quiet",
      getOption(
        "usethis.quiet",
        default = FALSE
      )
    )
  ) {
    force(expr)
  }
}

# This functions checks that the 'name' argument
# of add_module() does not start with 'mod_' as
# this is prepended by add_module() per default.
check_name_syntax <- function(name) {
  if (isTRUE(grepl("^mod_", name))) {
    cli_cli_alert_info(
      "You set a 'name' that starts with 'mod_'."
    )
    cli_cli_alert_info(
      "This is not necessary as golem will prepend 'mod_' to your module name automatically."
    )
  }
}
