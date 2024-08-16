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
    if (rlang_is_interactive()) {
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
      # We don't create the file if we are not in
      # interactive mode
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
      gsub(
        "(\\s*#+[^'@].*$| #+[^#].*$)",
        "",
        line
      )
    )
  }
  lines_without_comment <- lines_without_comment[lines_without_comment != ""]
  writeLines(
    text = lines_without_comment,
    con = file
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
# for testing purposes
utils_menu <- function(...) {
  utils::menu(...)
}
yesno <- function(...) {
  cat(paste0(..., collapse = ""))
  utils_menu(c("Yes", "No")) == 1
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
is_existing_module <- function(
  module,
  pkg = "."
) {
  stopifnot(`Cannot be called when not inside a R-package` = dir.exists(
    file.path(pkg, "R")
  ))
  # stopifnot(`Cannot be called when not inside a golem-project` = is.golem())
  existing_module_files <- list.files(
    file.path(
      pkg,
      "R/"
    ),
    pattern = "^mod_"
  )
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
check_name_length_is_one <- function(name) {
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
