#' @export
#' @rdname add_files
#' @importFrom tools file_ext
add_js_file <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  with_doc_ready = TRUE,
  template = golem::js_template,
  ...
) {
  stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  name <- file_path_sans_ext(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.js", name)
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)
    if (with_doc_ready) {
      write_there <- function(...) {
        write(..., file = where, append = TRUE)
      }
      write_there("$( document ).ready(function() {")
      template(path = where, ...)
      write_there("});")
    } else {
      template(path = where, ...)
    }
    file_created_dance(
      where,
      after_creation_message_js,
      pkg,
      dir,
      name,
      open
    )
  } else {
    file_already_there_dance(
      where = where,
      open_file = open
    )
  }
}

#' @export
#' @rdname add_files
add_js_handler <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  template = golem::js_handler_template,
  ...
) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  name <- file_path_sans_ext(name)

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.js", name)
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    template(path = where, ...)

    file_created_dance(
      where,
      after_creation_message_js,
      pkg,
      dir,
      name,
      open_file = open
    )
  } else {
    file_already_there_dance(
      where,
      open_file = open
    )
  }
}

#' @export
#' @rdname add_files
add_js_input_binding <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE,
  initialize = FALSE,
  dev = FALSE,
  events = list(
    name = "click",
    rate_policy = FALSE
  )
) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  attempt::stop_if(
    length(events$name) == 0,
    msg = "At least one event is required"
  )

  attempt::stop_if(
    length(events$name) != length(events$rate_policy),
    msg = "Incomplete events list"
  )

  raw_name <- name

  name <- file_path_sans_ext(
    sprintf("input-%s", name)
  )

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.js", name)
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- function(...) {
      write(..., file = where, append = TRUE)
    }

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


    file_created_dance(
      where,
      after_creation_message_js,
      pkg,
      dir,
      name,
      open_file = open
    )
  } else {
    file_already_there_dance(
      where,
      open_file = open
    )
  }
}

#' @export
#' @rdname add_files
add_js_output_binding <- function(
  name,
  pkg = get_golem_wd(),
  dir = "inst/app/www",
  open = TRUE,
  dir_create = TRUE
) {
  attempt::stop_if(
    missing(name),
    msg = "`name` is required"
  )

  check_name_length(name)

  raw_name <- name

  name <- file_path_sans_ext(
    sprintf("output-%s", name)
  )

  old <- setwd(fs_path_abs(pkg))
  on.exit(setwd(old))

  dir_created <- create_if_needed(
    dir,
    type = "directory"
  )

  if (!dir_created) {
    cat_dir_necessary()
    return(invisible(FALSE))
  }

  dir <- fs_path_abs(dir)

  where <- fs_path(
    dir,
    sprintf("%s.js", name)
  )

  if (!fs_file_exists(where)) {
    fs_file_create(where)

    write_there <- function(...) {
      write(..., file = where, append = TRUE)
    }

    # write in the file!

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


    file_created_dance(
      where,
      after_creation_message_js,
      pkg,
      dir,
      name,
      open_file = open
    )
  } else {
    file_already_there_dance(
      where,
      open_file = open
    )
  }
}