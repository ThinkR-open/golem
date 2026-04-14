#!/usr/bin/env Rscript

# Based on Arthur Bréant's missing-namespace checker idea from the stale golem
# PR 1159: https://github.com/ThinkR-open/golem/pull/1159

usage <- function() {
  cat(
    paste(
      "Usage:",
      "  Rscript scripts/find_missing_ns.R [OPTIONS]",
      "",
      "Find likely missing ns() wrappers in golem/Shiny module UI code.",
      "",
      "Options:",
      "  --path PATH            Project root to scan. Defaults to the current working directory.",
      "  --all-files            Scan all R/*.R files. Defaults to R/mod_*.R files only.",
      "  --functions REGEX      Extra UI function-name regex to check, for project helpers.",
      "                         Example: --functions '^sk_.*_input$|^myWidget$'",
      "  --format FORMAT        Output format: text, tsv, csv. Defaults to text.",
      "  --help                 Show this help message.",
      "",
      "Exit codes:",
      "  0  No likely missing ns() calls found.",
      "  1  One or more likely missing ns() calls found.",
      "  2  Invalid arguments or scan error.",
      "",
      "Examples:",
      "  Rscript .agents/skills/golem-fix-missing-ns/scripts/find_missing_ns.R",
      "  Rscript .claude/skills/golem-fix-missing-ns/scripts/find_missing_ns.R --format tsv",
      "  Rscript scripts/find_missing_ns.R --path /path/to/app --all-files",
      sep = "\n"
    ),
    "\n"
  )
}

fail <- function(message) {
  cat("Error: ", message, "\n", sep = "", file = stderr())
  quit(status = 2, save = "no")
}

parse_args <- function(args) {
  out <- list(
    path = ".",
    all_files = FALSE,
    functions = character(),
    format = "text",
    help = FALSE
  )

  i <- 1L
  while (i <= length(args)) {
    arg <- args[[i]]

    if (identical(arg, "--help") || identical(arg, "-h")) {
      out$help <- TRUE
    } else if (identical(arg, "--all-files")) {
      out$all_files <- TRUE
    } else if (identical(arg, "--path")) {
      i <- i + 1L
      if (i > length(args)) fail("--path requires a value")
      out$path <- args[[i]]
    } else if (startsWith(arg, "--path=")) {
      out$path <- sub("^--path=", "", arg)
    } else if (identical(arg, "--functions")) {
      i <- i + 1L
      if (i > length(args)) fail("--functions requires a value")
      out$functions <- c(out$functions, args[[i]])
    } else if (startsWith(arg, "--functions=")) {
      out$functions <- c(out$functions, sub("^--functions=", "", arg))
    } else if (identical(arg, "--format")) {
      i <- i + 1L
      if (i > length(args)) fail("--format requires a value")
      out$format <- args[[i]]
    } else if (startsWith(arg, "--format=")) {
      out$format <- sub("^--format=", "", arg)
    } else {
      fail(sprintf("unknown argument: %s", arg))
    }

    i <- i + 1L
  }

  if (!out$format %in% c("text", "tsv", "csv")) {
    fail("--format must be one of: text, tsv, csv")
  }

  out
}

module_files <- function(root, all_files = FALSE) {
  r_dir <- file.path(root, "R")
  if (!dir.exists(r_dir)) {
    fail(sprintf("R directory not found under %s", normalizePath(root, mustWork = FALSE)))
  }

  pattern <- if (isTRUE(all_files)) "[.]R$" else "^mod_.*[.]R$"
  list.files(
    r_dir,
    pattern = pattern,
    full.names = TRUE,
    recursive = TRUE,
    ignore.case = FALSE
  )
}

parse_file_data <- function(path) {
  parsed <- parse(file = path, keep.source = TRUE)
  data <- utils::getParseData(parsed)
  if (is.null(data)) {
    data.frame()
  } else {
    data[order(data$line1, data$col1, data$id), , drop = FALSE]
  }
}

parent_of <- function(data, id) {
  row <- match(id, data$id)
  if (is.na(row)) {
    NA_integer_
  } else {
    data$parent[[row]]
  }
}

ancestors_of <- function(data, id) {
  ancestors <- integer()
  parent <- parent_of(data, id)
  while (!is.na(parent) && parent != 0L) {
    ancestors <- c(ancestors, parent)
    parent <- parent_of(data, parent)
  }
  ancestors
}

descendant_rows <- function(data, id) {
  data$v <- vapply(
    data$id,
    function(candidate) id %in% ancestors_of(data, candidate),
    logical(1)
  )
  data[data$v, setdiff(names(data), "v"), drop = FALSE]
}

call_table <- function(data) {
  calls <- data[data$token == "SYMBOL_FUNCTION_CALL", , drop = FALSE]
  if (!nrow(calls)) {
    return(data.frame())
  }

  function_expr <- data[match(calls$parent, data$id), , drop = FALSE]
  call_expr <- data[match(function_expr$parent, data$id), , drop = FALSE]

  data.frame(
    call_id = call_expr$id,
    function_name = calls$text,
    line1 = call_expr$line1,
    col1 = call_expr$col1,
    line2 = call_expr$line2,
    col2 = call_expr$col2,
    stringsAsFactors = FALSE
  )
}

nearest_call_for_string <- function(data, calls, string_id) {
  ancestors <- ancestors_of(data, string_id)
  call_ids <- ancestors[ancestors %in% calls$call_id]
  if (!length(call_ids)) {
    return(NULL)
  }

  calls[match(call_ids[[1]], calls$call_id), , drop = FALSE]
}

direct_argument_expr <- function(data, call_id, string_id) {
  chain <- c(string_id, ancestors_of(data, string_id))
  direct <- chain[vapply(chain, function(id) identical(parent_of(data, id), call_id), logical(1))]
  if (!length(direct)) {
    NA_integer_
  } else {
    direct[[1]]
  }
}

argument_name <- function(data, call_id, argument_expr_id) {
  children <- data[data$parent == call_id, , drop = FALSE]
  children <- children[order(children$line1, children$col1, children$id), , drop = FALSE]
  idx <- match(argument_expr_id, children$id)
  if (is.na(idx)) {
    return(NA_character_)
  }

  previous <- children[seq_len(idx - 1L), , drop = FALSE]
  comma_rows <- which(previous$token == "','")
  after_last_comma <- if (length(comma_rows)) max(comma_rows) + 1L else 1L
  segment <- previous[after_last_comma:nrow(previous), , drop = FALSE]
  symbol_sub <- segment[segment$token == "SYMBOL_SUB", , drop = FALSE]

  if (nrow(symbol_sub)) {
    symbol_sub$text[[nrow(symbol_sub)]]
  } else {
    NA_character_
  }
}

argument_position <- function(data, call_id, argument_expr_id) {
  children <- data[data$parent == call_id, , drop = FALSE]
  children <- children[order(children$line1, children$col1, children$id), , drop = FALSE]
  argument_exprs <- children[children$token == "expr", , drop = FALSE]
  match(argument_expr_id, argument_exprs$id)
}

has_ns_ancestor <- function(data, calls, string_id) {
  ancestors <- ancestors_of(data, string_id)
  ancestor_calls <- calls[calls$call_id %in% ancestors, , drop = FALSE]
  any(ancestor_calls$function_name == "ns")
}

is_candidate_function <- function(function_name, extra_patterns = character()) {
  known <- c(
    "actionButton", "actionLink", "checkboxGroupInput", "checkboxInput",
    "dateInput", "dateRangeInput", "fileInput", "numericInput",
    "passwordInput", "radioButtons", "selectInput", "selectizeInput",
    "sliderInput", "textAreaInput", "textInput", "varSelectInput",
    "varSelectizeInput", "downloadButton", "downloadLink",
    "dataTableOutput", "htmlOutput", "imageOutput", "plotOutput",
    "tableOutput", "textOutput", "uiOutput", "verbatimTextOutput"
  )

  if (startsWith(function_name, "update")) {
    return(FALSE)
  }

  function_name %in% known ||
    grepl("(Input|Output)$", function_name) ||
    grepl("^mod_.+_ui$", function_name) ||
    any(vapply(extra_patterns, grepl, logical(1), x = function_name))
}

argument_requires_ns <- function(function_name, argument_name, argument_position) {
  module_ui <- grepl("^mod_.+_ui$", function_name)
  id_names <- c("inputId", "outputId", "id", "brush", "click", "dblclick", "hover")

  if (!is.na(argument_name)) {
    return(argument_name %in% id_names)
  }

  if (is.na(argument_position)) {
    return(FALSE)
  }

  argument_position == 1L && (module_ui || is_candidate_function(function_name))
}

dequote_string <- function(x) {
  out <- tryCatch(eval(parse(text = x)), error = function(e) x)
  if (is.character(out) && length(out) == 1L) {
    out
  } else {
    x
  }
}

find_missing_ns_in_file <- function(path, extra_patterns = character()) {
  data <- parse_file_data(path)
  if (!nrow(data)) {
    return(data.frame())
  }

  calls <- call_table(data)
  if (!nrow(calls)) {
    return(data.frame())
  }

  strings <- data[data$token == "STR_CONST", , drop = FALSE]
  findings <- list()

  for (i in seq_len(nrow(strings))) {
    string <- strings[i, , drop = FALSE]

    if (has_ns_ancestor(data, calls, string$id)) {
      next
    }

    call <- nearest_call_for_string(data, calls, string$id)
    if (is.null(call) || !is_candidate_function(call$function_name, extra_patterns)) {
      next
    }

    arg_expr_id <- direct_argument_expr(data, call$call_id, string$id)
    arg_name <- argument_name(data, call$call_id, arg_expr_id)
    arg_position <- argument_position(data, call$call_id, arg_expr_id)

    if (!argument_requires_ns(call$function_name, arg_name, arg_position)) {
      next
    }

    findings[[length(findings) + 1L]] <- data.frame(
      file = path,
      line = string$line1,
      column = string$col1,
      function_name = call$function_name,
      argument = ifelse(is.na(arg_name), paste0("#", arg_position), arg_name),
      id = dequote_string(string$text),
      suggestion = paste0("wrap as ns(", string$text, ")"),
      stringsAsFactors = FALSE
    )
  }

  if (!length(findings)) {
    data.frame()
  } else {
    do.call(rbind, findings)
  }
}

find_missing_ns <- function(root = ".", all_files = FALSE, extra_patterns = character()) {
  root <- normalizePath(root, mustWork = TRUE)
  files <- module_files(root, all_files = all_files)

  if (!length(files)) {
    return(data.frame(
      file = character(),
      line = integer(),
      column = integer(),
      function_name = character(),
      argument = character(),
      id = character(),
      suggestion = character(),
      stringsAsFactors = FALSE
    ))
  }

  results <- lapply(
    files,
    function(file) {
      tryCatch(
        find_missing_ns_in_file(file, extra_patterns = extra_patterns),
        error = function(e) {
          data.frame(
            file = file,
            line = NA_integer_,
            column = NA_integer_,
            function_name = "<parse error>",
            argument = NA_character_,
            id = NA_character_,
            suggestion = conditionMessage(e),
            stringsAsFactors = FALSE
          )
        }
      )
    }
  )

  out <- do.call(rbind, results)
  rownames(out) <- NULL
  out
}

print_text <- function(results) {
  if (!nrow(results)) {
    cat("No likely missing ns() calls found.\n")
    return(invisible())
  }

  cat(sprintf("Found %d likely missing ns() call%s:\n", nrow(results), ifelse(nrow(results) == 1L, "", "s")))
  for (i in seq_len(nrow(results))) {
    item <- results[i, , drop = FALSE]
    cat(
      sprintf(
        "- %s:%s:%s `%s(%s = \"%s\")`; %s\n",
        item$file,
        item$line,
        item$column,
        item$function_name,
        item$argument,
        item$id,
        item$suggestion
      )
    )
  }
}

print_results <- function(results, format) {
  if (identical(format, "text")) {
    print_text(results)
  } else if (identical(format, "tsv")) {
    utils::write.table(
      results,
      file = stdout(),
      sep = "\t",
      row.names = FALSE,
      quote = TRUE,
      na = ""
    )
  } else {
    utils::write.csv(
      results,
      file = stdout(),
      row.names = FALSE,
      na = ""
    )
  }
}

main <- function() {
  args <- parse_args(commandArgs(trailingOnly = TRUE))
  if (isTRUE(args$help)) {
    usage()
    return(invisible(0L))
  }

  results <- find_missing_ns(
    root = args$path,
    all_files = args$all_files,
    extra_patterns = args$functions
  )
  print_results(results, args$format)

  if (nrow(results)) {
    quit(status = 1L, save = "no")
  }

  invisible(0L)
}

if (identical(sys.nframe(), 0L)) {
  tryCatch(
    main(),
    error = function(e) fail(conditionMessage(e))
  )
}
