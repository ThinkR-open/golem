#' Create Files
#'
#' These functions create files inside the `inst/app` folder.
#'
#' @inheritParams  add_module
#' @param dir_create Deprecated. Will be removed in future versions and throws an error for now.
#' @param dir Path to the dir where the file while be created.
#' @param with_doc_ready For JS file - Should the default file include `$( document ).ready()`?
#' @param template Function writing in the created file.
#' You may overwrite this with your own template function.
#' @param ... Arguments to be passed to the `template` function.
#' @param initialize For JS file - Whether to add the initialize method.
#'      Default to FALSE. Some JavaScript API require to initialize components
#'      before using them.
#' @param dev Whether to insert console.log calls in the most important
#'      methods of the binding. This is only to help building the input binding.
#'      Default is FALSE.
#' @param events List of events to generate event listeners in the subscribe method.
#'     For instance, `list(name = c("click", "keyup"), rate_policy = c(FALSE, TRUE))`.
#'     The list contain names and rate policies to apply to each event. If a rate policy is found,
#'     the debounce method with a default delay of 250 ms is applied. You may edit manually according to
#'     <https://shiny.rstudio.com/articles/building-inputs.html>
#' @export
#' @rdname add_files
#' @importFrom attempt stop_if
#' @importFrom utils file.edit
#'
#' @note `add_ui_server_files` will be deprecated in future version of `{golem}`
#'
#' @seealso \code{\link{js_template}}, \code{\link{js_handler_template}}, and \code{\link{css_template}}
#'
#' @return The path to the file, invisibly.
add_js_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  with_doc_ready = TRUE,
  template = golem::js_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  temp_js <- tempfile(fileext = ".js")
  write_there <- write_there_builder(temp_js)

  if (with_doc_ready) {
    write_there("$( document ).ready(function() {")
    template(path = temp_js, ...)
    write_there("});")
  } else {
    template(path = temp_js, ...)
  }

  use_internal_js_file(
    path = temp_js,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_js_handler <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::js_handler_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  temp_js <- tempfile(fileext = ".js")

  template(path = temp_js, ...)

  use_internal_js_file(
    path = temp_js,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_js_input_binding <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  initialize = FALSE,
  dev = FALSE,
  events = list(
    name = "click",
    rate_policy = FALSE
  )
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  attempt::stop_if(
    length(events$name) == 0,
    msg = "At least one event is required"
  )

  attempt::stop_if(
    length(events$name) != length(events$rate_policy),
    msg = "Incomplete events list"
  )

  temp_js <- tempfile(fileext = ".js")

  raw_name <- name

  name <- file_path_sans_ext(
    sprintf("input-%s", name)
  )

  temp_js <- tempfile(fileext = ".js")

  write_there <- write_there_builder(temp_js)

  # If we find at least 1 event with a rate policy, we allow
  # the getRatePolicy method
  global_rate_policy <- sum(sapply(events$rate_policy, `[[`, 1)) > 0

  write_there(sprintf("var %s = new Shiny.InputBinding();", raw_name))
  write_there(sprintf("$.extend(%s, {", raw_name))
  # find
  write_there("  find: function(scope) {")
  write_there("    // JS logic $(scope).find('whatever')")
  write_there("  },")
  # initialize
  if (initialize) {
    write_there("  initialize: function(el) {")
    write_there("    // optional part. Only if the input relies on a JS API with specific initialization.")
    write_there("  },")
  }
  # get value
  write_there("  getValue: function(el) {")
  if (dev) write_there("    console.log($(el));")
  write_there("    // JS code to get value")
  write_there("  },")
  # set value
  write_there("  setValue: function(el, value) {")
  if (dev) write_there("    console.log('New value is: ' + value);")
  write_there("    // JS code to set value")
  write_there("  },")
  # receive
  write_there("  receiveMessage: function(el, data) {")
  write_there("    // this.setValue(el, data);")
  if (dev) write_there("    console.log('Updated ...');")
  write_there("  },")
  # subscribe
  write_there("  subscribe: function(el, callback) {")
  # list of event listeners
  lapply(seq_along(events$name), function(i) {
    write_there(sprintf("    $(el).on('%s.%s', function(e) {", events$name[i], raw_name))
    if (events$rate_policy[i]) {
      write_there("      callback(true);")
    } else {
      write_there("      callback();")
    }
    if (dev) write_there("      console.log('Subscribe ...');")
    write_there("    });")
    write_there("")
  })
  write_there("  },")

  # rate policy if any
  if (global_rate_policy) {
    write_there("  getRatePolicy: function() {")
    write_there("    return {")
    write_there("      policy: 'debounce',")
    write_there("      delay: 250")
    write_there("    };")
    write_there("  },")
  }

  # unsubscribe
  write_there("  unsubscribe: function(el) {")
  write_there(sprintf("    $(el).off('.%s');", raw_name))
  write_there("  }")

  # end
  write_there("});")
  write_there(sprintf("Shiny.inputBindings.register(%s, 'shiny.whatever');", raw_name))

  use_internal_js_file(
    path = temp_js,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_js_output_binding <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  raw_name <- name

  name <- file_path_sans_ext(
    sprintf("output-%s", name)
  )

  temp_js <- tempfile(fileext = ".js")

  write_there <- write_there_builder(temp_js)

  write_there(sprintf("var %s = new Shiny.OutputBinding();", raw_name))
  write_there(sprintf("$.extend(%s, {", raw_name))
  # find
  write_there("  find: function(scope) {")
  write_there("    // JS logic $(scope).find('whatever')")
  write_there("  },")
  # renderValue
  write_there("  renderValue: function(el, data) {")
  write_there("    // JS logic")
  write_there("  }")
  # end
  write_there("});")
  write_there(sprintf("Shiny.outputBindings.register(%s, 'shiny.whatever');", raw_name))

  use_internal_js_file(
    path = temp_js,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_css_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::css_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  temp_css <- tempfile(fileext = ".css")
  template(path = temp_css, ...)

  use_internal_css_file(
    path = temp_css,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_sass_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::sass_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  temp_js <- tempfile(fileext = ".sass")
  template(path = temp_js, ...)

  add_sass_code_to_dev_script(
    dir = dir,
    name = name
  )

  use_internal_file(
    path = temp_js,
    name = sprintf(
      "%s.sass",
      name
    ),
    pkg = pkg,
    dir = dir,
    open = open
  )

  on.exit({
    cat_green_tick(
      "After running the compilation, your CSS file will be automatically link in `golem_add_external_resources()`."
    )
  })
}

add_sass_code_to_dev_script <- function(dir, name) {
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

#' @export
#' @rdname add_files
#' @importFrom tools file_ext
add_empty_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create,
  template = golem::empty_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }


  check_name_length_is_one(name)

  extension <- file_ext(name)

  if (extension == "js") {
    warning("We've noticed you are trying to create a .js file. \nYou may want to use `add_js_file()` in future calls.")
    return(
      add_js_file(
        name = name,
        pkg = pkg,
        dir = dir,
        open = open,
        template = template,
        ...
      )
    )
  }
  if (extension == "css") {
    warning("We've noticed you are trying to create a .css file. \nYou may want to use `add_css_file()` in future calls.")
    return(
      add_css_file(
        name = name,
        pkg = pkg,
        dir = dir,
        open = open,
        template = template,
        ...
      )
    )
  }
  if (extension == "sass") {
    warning("We've noticed you are trying to create a .sass file. \nYou may want to use `add_sass_file()` in future calls.")
    return(
      add_sass_file(
        name = name,
        pkg = pkg,
        dir = dir,
        open = open,
        template = template,
        ...
      )
    )
  }
  if (extension == "html") {
    warning("We've noticed you are trying to create a .html file. \nYou may want to use `add_html_template()` in future calls.")
    return(
      add_html_template(
        name = name,
        pkg = pkg,
        dir = dir,
        open = open
      )
    )
  }

  temp_file <- tempfile()
  template(path = temp_file, ...)
  use_internal_file(
    path = temp_file,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_html_template <- function(
  name = "template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }

  temp_html <- tempfile(fileext = ".html")
  write_there <- write_there_builder(temp_html)

  write_there("<!DOCTYPE html>")
  write_there("<html>")
  write_there("  <head>")
  write_there(
    sprintf(
      "    <title>%s</title>",
      get_golem_name()
    )
  )
  write_there("  </head>")
  write_there("  <body>")
  write_there("    {{ body }}")
  write_there("  </body>")
  write_there("</html>")
  write_there("")

  use_internal_html_template(
    path = temp_html,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_partial_html_template <- function(
  name = "partial_template.html",
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create
) {
  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }
  temp_html <- tempfile(fileext = ".html")
  write_there <- write_there_builder(temp_html)

  write_there("<div>")
  write_there("  {{ content }}")
  write_there("</div>")
  write_there("")

  use_internal_html_template(
    path = temp_html,
    name = name,
    pkg = pkg,
    dir = dir,
    open = open
  )
}

#' @export
#' @rdname add_files
add_ui_server_files <- function(
  pkg = get_golem_wd(),
  dir = "inst/app",
  dir_create
) {
  if (!missing(dir_create)) {
    cli_cli_abort(
      "The dir_create argument is deprecated."
    )
  }
  .Deprecated(msg = "This function will be deprecated in a future version of {golem}.\nPlease comment on https://github.com/ThinkR-open/golem/issues/445 if you want it to stay.")

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir <- fs_path_abs(dir)
  check_directory_exists(dir)

  # UI
  where <- fs_path(dir, "ui.R")

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- write_there_builder(where)

    pkg <- get_golem_name()

    write_there(
      sprintf("%s:::app_ui()", pkg)
    )

    cat_created(where, "ui file")
  } else {
    cat_green_tick("UI file already exists.")
  }

  # server
  where <- file.path(
    dir,
    "server.R"
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- write_there_builder(where)

    write_there(
      sprintf(
        "%s:::app_server",
        pkg
      )
    )
    cat_created(where, "server file")
  } else {
    cat_green_tick("server file already exists.")
  }
}
