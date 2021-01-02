#' Sanity check for R files in the project
#' 
#' This function checks that modules and element ids are used consistently, it also check for any 'browser()' or commented
#' #TODO / #TOFIX / #BUG in the code.
#' @rdname sanity_check
#' @export
#' @importFrom rstudioapi sourceMarkers
#' @importFrom rstudioapi getActiveProject
sanity_check<- function(){
  active_project_dir <- rstudioapi::getActiveProject()
  all_R_files <-list.files(path = active_project_dir, pattern = "\\.R$", recursive = TRUE, )
  module_files <- grep("R/mod[_a-z]+\\.R", all_R_files, value = TRUE)
  non_module_files <- setdiff(all_R_files, module_files)
  env <- parent.frame()
  
  to_find <- c('browser()', '#\\s*TODO', '#\\s*TOFIX', '#\\s*BUG')
  
  general_markers <-
    lapply(all_R_files, check_no_browser_or_special_comment, to_find)
  
  module_markers <- lapply(module_files, function(file_name) {
    base_name <- basename(file_name)
    mod_name <- substr(base_name,5, nchar(base_name)-2)
    parse_data <- utils::getParseData(parse(file_name, keep.source = TRUE), includeText = TRUE)
    
    ui_parse_data     <- parse_data_subset(parse_data, "ui", mod_name)
    server_parse_data <- parse_data_subset(parse_data, "server", mod_name)
    
    rbind(
      check_modules_contain_right_functions(parse_data, file_name, mod_name),
      check_mod_ui(ui_parse_data, file_name, mod_name, env),
      check_mod_server(server_parse_data, file_name, mod_name, env),
      check_ui_server_consistency(ui_parse_data, server_parse_data, file_name, mod_name, env)
    )
  })
  
  source_markers <- do.call(rbind, c(general_markers, module_markers))
  
  if(length(source_markers) > 0){
    rstudioapi::sourceMarkers("sanity_check", markers = source_markers)
  }
  else{
    message("No errors found. Sanity check passed successfully.")
  }
}

parse_data_subset <- function(parse_data, server_or_ui, mod_name) {
  parse_data <- parse_data
  parse_data$keep <- 
    startsWith(parse_data$text, paste0("mod_", mod_name, "_", server_or_ui))  & 
    parse_data$parent == 0
  new_id <- parse_data$id[parse_data$keep]
  while(length(new_id)) {
    new_id <- parse_data$id[parse_data$parent %in% new_id]
    parse_data$keep[parse_data$id %in% new_id] <- TRUE
  }
  parse_data <- subset(parse_data, keep)
  parse_data$keep <- NULL
  parse_data
}

check_no_browser_or_special_comment <- function(file_name, to_find) {
  source_markers <- NULL
  file <- readLines(file_name, warn = FALSE)
  for ( word in to_find){
    line_number <- grep(word, file, fixed = TRUE)
    if(length(line_number) > 0){
      df <- data.frame(
        type = "warning",
        file = file_name,
        line = 1,
        message = paste("Found", word, sep=" "),
        column = 1
      )
      source_markers <- rbind.data.frame(source_markers, df)
    }
  }
  source_markers
}

check_modules_contain_right_functions <- function(parse_data, file_name, mod_name) {
  # assignments
  assigment_expr_id <- parse_data$parent[parse_data$token %in% c("LEFT_ASSIGN", "EQ_ASSIGN")]
  # top level calls
  top_level_expr_id <- parse_data$id[parse_data$parent == 0 & parse_data$token == "expr"]
  # top level assignments
  top_level_assigment_expr_id <- intersect(assigment_expr_id, top_level_expr_id)
  # lhs
  lhs_id <- sapply(top_level_assigment_expr_id, function(x) parse_data$id[parse_data$parent == x][1])
  
  clean_data <- subset(parse_data, id %in% lhs_id, select = c("line1", "col1", "text"))
  
  server_fun_name <- paste0("mod_", mod_name, "_server")
  ui_fun_name <- paste0("mod_", mod_name, "_ui")
  missing_server_fun_markers <- if(!server_fun_name %in% clean_data$text) {
    data.frame(
      type = "warning", 
      file = file_name, 
      line = -1, 
      message = sprintf("Server function `%s` is not defined", server_fun_name), 
      column = -1 )
  }
  
  missing_ui_fun_markers <- if(!ui_fun_name %in% clean_data$text) {
    data.frame(
      type = "warning", 
      file = file_name, 
      line = -1, 
      message = sprintf("UI function `%s` is not defined", ui_fun_name), 
      column = -1 )
  }
  
  # if a function name is different from accepted name, error with relevant line
  unexpected_funs_data <- 
    subset(clean_data, !text %in% c(server_fun_name, ui_fun_name))
  
  unexpected_fun_markers <- if(nrow(unexpected_funs_data)) {
    with(unexpected_funs_data, data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf("Found unexpected definition of `%s`", text), 
      column = col1 ))
  }
  
  rbind(
    missing_server_fun_markers, 
    missing_ui_fun_markers, 
    unexpected_fun_markers)
}

check_mod_ui <- function(ui_parse_data, file_name, mod_name, env) {
  # we look for SYMBOL_FUNCTION_CALL and go 2 parents up to find function call
  parent_id <- ui_parse_data$parent[ui_parse_data$token == "SYMBOL_FUNCTION_CALL"]
  calls_id <- ui_parse_data$parent[ui_parse_data$id %in% parent_id]
  
  calls_data <- 
    subset(ui_parse_data, id %in% calls_id, select = c("line1", "col1", "text", "parent", "id"))
  
  # for all calls we'll check if we know the function, if we do we'll check if
  # they have an id arg, if they do we check if it is a call to ns or NS
  calls_data$calls <- as.list(parse(text = calls_data$text))
  calls_data$fun_sym <- lapply(calls_data$calls, .subset2, 1)
  calls_data$fun_chr <- as.character(calls_data$fun_sym)
  calls_data$fun_exists <- sapply(calls_data$fun_chr, exists, env)
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # check if module functions exist and if the id argument is named right
  
  module_calls_data <- subset(calls_data, grepl("^mod_(.*)_ui$", fun_chr))
  
  if(nrow(module_calls_data)) {
    module_calls_data$mod <- gsub("^mod_(.*)_ui$", "\\1", module_calls_data$fun_chr)
    module_calls_data$id <- sapply(module_calls_data$calls, function(x) {
      if(!is.call(x[[2]])) return(NA) # call with no arg or not namespaced
      if(identical(x[[c(2,1)]], quote(ns))) {
        id <- if (is.character(x[[c(2,2)]]))  x[[c(2,2)]] else NA
      } else     if(identical(x[[c(2,1)]], quote(NS))) {
        call <- match.call(shiny::NS, x[[2]])
        id <- if (is.character(call[["id"]]))  call[["id"]] else NA
      } else {
        id <- NA
      }
    })
    module_calls_data$wrong_id <- 
      !is.na(module_calls_data$id) &
      !startsWith(module_calls_data$id, paste0(module_calls_data$mod, "_"))
    
    inexistent_module_markers <- if(!all(module_calls_data$fun_exists)) {
      with(subset(module_calls_data, !fun_exists), data.frame(
        type = "warning", 
        file = file_name, 
        line = line1, 
        message = sprintf(
          "The UI module function `%s` is used but doesn't exist.", 
          fun_chr), 
        column = col1 ))
    }
    
    wrong_module_id_markers <- if(any(module_calls_data$wrong_id)) {
      with(subset(module_calls_data, wrong_id), data.frame(
        type = "warning", 
        file = file_name, 
        line = line1, 
        message = sprintf(
          "The UI module function `%s` refers to the id `%s`, which is not prefixed by `%s`.", 
          fun_chr, id, paste0(mod, "_")), 
        column = col1 ))
    }
  } else {
    inexistent_module_markers <- wrong_module_id_markers <- NULL
  }
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # make sure ns() or NS() are not used if arg is not id, inputId or outputId
  ns_parents_id <- calls_data$parent[calls_data$fun_chr %in% c("NS","ns")]
  ns_wrappers_data <- subset(calls_data, id %in% ns_parents_id & fun_exists)
  ns_wrappers_data$fun_val <- lapply(ns_wrappers_data$fun_sym, eval, env)
  ns_wrappers_data$calls <- Map(match.call, ns_wrappers_data$fun_val, ns_wrappers_data$calls)
  # we control only the first use, maybe we could also 
  ns_wrappers_data$msg <- sapply(ns_wrappers_data$calls, function(call) {
    ns_lgl <- sapply(call, function(arg) is.call(arg) && list(arg[[1]]) %in% list(quote(NS), quote(ns)))
    ns_lgl[c("id", "inputId", "outputId")] <- FALSE
    if(any(ns_lgl)) {
      names(ns_lgl)[allNames(ns_lgl) == ""] <- "..."
      ns_or_NS <- as.character(call[[which(ns_lgl)[1]]][[1]])
      wrong_arg <- names(ns_lgl)[ns_lgl][1]
      sprintf(
        "In a call to `%s`, `%s` was used to wrap a `%s` argument, we expect it to wrap only `id`, `inputId` or `ouputId`",
        as.character(call[[1]]), ns_or_NS, wrong_arg)
    } else NA
  })
  ns_wrappers_data <- subset(ns_wrappers_data, !is.na(msg))
  wrong_ns_markers <- if(nrow(ns_wrappers_data)) {
    with(ns_wrappers_data, data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = msg, 
      column = col1 ))
  }
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # check if id args are wrapped inside ns() or NS()
  
  calls_data <- subset(calls_data, fun_exists)
  if(!nrow(calls_data)) 
    return(rbind(
      inexistent_module_markers,
      wrong_module_id_markers,
      wrong_ns_markers))
  calls_data$fun_val <- lapply(calls_data$fun_sym, eval, env)
  calls_data$calls <- Map(match.call, calls_data$fun_val, calls_data$calls)
  calls_data$has_id <- 
    sapply(calls_data$calls, function(x) "id" %in% names(x))
  calls_data$has_inputid <- 
    sapply(calls_data$calls, function(x) "inputId" %in% names(x))
  calls_data$has_outputid <- 
    sapply(calls_data$calls, function(x) "outputId" %in% names(x))
  
  # id arguments
  id_data <- subset(calls_data, has_id)
  id_data$id_arg <- lapply(id_data$calls, .subset2, "id")
  id_data$has_ns <- sapply(id_data$id_arg, function(x)
    is.call(x) && list(x[[1]]) %in% list(quote(NS), quote(ns)))
  wrong_id_markers <- if(!all(id_data$has_ns)) {
    with(subset(id_data, !has_ns), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf(
        "The `id` argument of `%s` is not wrapped inside `ns()` or `NS()`", 
        fun_chr), 
      column = col1 ))
  }
  
  # inputid arguments
  inputid_data <- subset(calls_data, has_inputid)
  inputid_data$inputid_arg <- lapply(inputid_data$calls, .subset2, "inputId")
  inputid_data$has_ns <- sapply(inputid_data$inputid_arg, function(x)
    is.call(x) && list(x[[1]]) %in% list(quote(NS), quote(ns)))
  wrong_inputid_markers <- if(!all(inputid_data$has_ns)) {
    with(subset(inputid_data, !has_ns), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf(
        "The `inputid` argument of `%s` is not wrapped inside `ns()` or `NS()`", 
        fun_chr), 
      column = col1 ))
  }
  
  # outputid arguments
  outputid_data <- subset(calls_data, has_outputid)
  outputid_data$outputid_arg <- lapply(outputid_data$calls, .subset2, "outputId")
  outputid_data$has_ns <- sapply(outputid_data$outputid_arg, function(x)
    is.call(x) && list(x[[1]]) %in% list(quote(NS), quote(ns)))
  wrong_outputid_markers <- if(!all(outputid_data$has_ns)) {
    with(subset(outputid_data, !has_ns), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf(
        "The `outputid` argument of `%s` is not wrapped inside `ns()` or `NS()`", 
        fun_chr), 
      column = col1 ))
  }
  
  rbind(
    inexistent_module_markers, 
    wrong_module_id_markers,
    wrong_ns_markers,
    wrong_id_markers, 
    wrong_inputid_markers, 
    wrong_outputid_markers)
}

check_mod_server <- function(server_parse_data, file_name, mod_name, env) {
  # we look for SYMBOL_FUNCTION_CALL and go 2 parents up to find function call
  parent_id <- server_parse_data$parent[
    server_parse_data$token == "SYMBOL_FUNCTION_CALL" & 
      server_parse_data$text %in% c("callModule", "moduleServer")]
  calls_id <- server_parse_data$parent[server_parse_data$id %in% parent_id]
  
  calls_data <- 
    subset(server_parse_data, id %in% calls_id, select = c("line1", "col1", "text", "parent", "id"))
  
  # for all calls we'll check if we know the function, if we do we'll check if
  # they have an id arg, if they do we check if it is a call to ns or NS
  calls_data$calls   <- as.list(parse(text = calls_data$text))
  calls_data$fun_sym <- lapply(calls_data$calls, .subset2, 1)
  calls_data$fun_chr <- as.character(calls_data$fun_sym)
  calls_data$calls   <- Map(
    function(x, call) match.call(base::get(x, env), call),
    calls_data$fun_chr, 
    calls_data$calls)
  calls_data$module <- lapply(calls_data$calls, .subset2, "module")
  calls_data$module_chr <- as.character(calls_data$module)
  calls_data$valid_module <- grepl("^mod_(.*)_server$", calls_data$module_chr)
  calls_data$module_exists <- sapply(calls_data$module_chr, exists, env)
  calls_data$id <- lapply(calls_data$calls, .subset2, "id")
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # check that arg is formatted as 'mod_MODULE_server'
  
  wrong_mod_name_markers <- 
    if(!all(calls_data$valid_module))
      with(subset(calls_data, !valid_module), data.frame(
        type = "warning", 
        file = file_name, 
        line = line1, 
        message = sprintf(
          "The module argument of `%s` is `%s` which is not of the form `mod_MODULE_server`", 
          fun_chr,
          module_chr), 
        column = col1 ))
  
  calls_data <- subset(calls_data, valid_module )
  if(!nrow(calls_data)) return(wrong_mod_name_markers)
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # check that the corresponding file exists
  inexistent_module_markers <- if(!all(calls_data$fun_exists)) {
    with(subset(calls_data, !fun_exists), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf(
        "The UI module function `%s` is used but doesn't exist.", 
        fun_chr), 
      column = col1 ))
  }
  
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # check that the id and module are compatible
  
  
  calls_data$mod_name <- sub("^mod_(.*)_server$" , "\\1", calls_data$module_chr)
  calls_data$id_compatible <- mapply(startsWith, as.character(calls_data$id), paste0(calls_data$mod_name, "_"))
  wrong_id_markers <- if(!all(calls_data$id_compatible))
    with(subset(calls_data, is.character(id) && !id_compatible), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1, 
      message = sprintf(
        "The module and id arguments of `%s` mismatch (`%s` and `\"%s\"`)", 
        fun_chr,
        module_chr,
        id), 
      column = col1 ))
  
  rbind(
    inexistent_module_markers, 
    wrong_mod_name_markers,
    wrong_id_markers)
}

check_ui_server_consistency <- function(ui_parse_data, server_parse_data, file_name, mod_name, env) {
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # server side
  
  # we look for SYMBOL_FUNCTION_CALL and go 2 parents up to find function call
  parent_id <- server_parse_data$parent[
    server_parse_data$token == "SYMBOL_FUNCTION_CALL" & 
      server_parse_data$text %in% c("callModule", "moduleServer")]
  calls_id <- server_parse_data$parent[server_parse_data$id %in% parent_id]
  
  server_calls_data <- 
    subset(server_parse_data, id %in% calls_id, select = c("line1", "col1", "text", "parent", "id"))
  
  # for all calls we'll check if we know the function, if we do we'll check if
  # they have an id arg, if they do we check if it is a call to ns or NS
  server_calls_data$calls   <- as.list(parse(text = server_calls_data$text))
  server_calls_data$fun_sym <- lapply(server_calls_data$calls, .subset2, 1)
  server_calls_data$fun_chr <- as.character(server_calls_data$fun_sym)
  server_calls_data$calls   <- Map(
    function(x, call) match.call(base::get(x, env), call),
    server_calls_data$fun_chr, 
    server_calls_data$calls)
  server_calls_data$module <- lapply(server_calls_data$calls, .subset2, "module")
  server_calls_data$module_chr <- as.character(server_calls_data$module)
  server_calls_data$module_exists <- lapply(server_calls_data$module_chr, exists, env)
  server_calls_data$ui_id <- vapply(server_calls_data$calls, .subset2, character(1), "id")
  server_calls_data$mod <- gsub("mod_(.*)_server", "\\1", server_calls_data$module_chr)
  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ui side
  parent_id <- ui_parse_data$parent[ui_parse_data$token == "SYMBOL_FUNCTION_CALL"]
  calls_id <- ui_parse_data$parent[ui_parse_data$id %in% parent_id]
  
  ui_calls_data <- 
    subset(ui_parse_data, id %in% calls_id, select = c("line1", "col1", "text", "parent", "id"))
  
  # for all calls we'll check if we know the function, if we do we'll check if
  # they have an id arg, if they do we check if it is a call to ns or NS
  ui_calls_data$calls <- as.list(parse(text = ui_calls_data$text))
  ui_calls_data$fun_sym <- lapply(ui_calls_data$calls, .subset2, 1)
  ui_calls_data$fun_chr <- as.character(ui_calls_data$fun_sym)
  ui_calls_data$fun_exists <- sapply(ui_calls_data$fun_chr, exists, env)
  ui_calls_data <- subset(ui_calls_data, grepl("^mod_(.*)_ui$", fun_chr))
  ui_calls_data$mod <- gsub("mod_(.*)_ui", "\\1", ui_calls_data$fun_chr)
  ui_calls_data$ui_id <- vapply(ui_calls_data$calls, function(x) {
    if(!is.call(x[[2]])) return(NA) # call with no arg or not namespaced
    if(identical(x[[c(2,1)]], quote(ns))) {
      id <- if (is.character(x[[c(2,2)]]))  x[[c(2,2)]] else NA
    } else     if(identical(x[[c(2,1)]], quote(NS))) {
      call <- match.call(shiny::NS, x[[2]])
      id <- if (is.character(call[["id"]]))  call[["id"]] else NA
    } else {
      id <- NA
    }
  },
  character(1))
  
  merged_data <- merge(
    server_calls_data[c("mod", "module_chr", "line1", "col1")],
    ui_calls_data[c("mod", "fun_chr", "line1", "col1")], by = "mod", all = TRUE, suffixes = c("_server", "_ui"))
  
  mod_server_only_markers <- if(anyNA(merged_data$fun_chr)) {
    with(subset(merged_data, is.na(fun_chr)), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1_server, 
      message = sprintf(
        "In 'mod_%s_server' is referenced in `mod_%s_server` but `mod_%s_ui` isn't referenced in `mod_%s_ui`'", 
        mod, mod_name, mod, mod_name), 
      column = col1_server ))
  }
  
  mod_ui_only_markers <- if(anyNA(merged_data$module_chr )) {
    with(subset(merged_data, is.na(module_chr )), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1_ui, 
      message = sprintf(
        "In 'mod_%s_ui' is referenced in `mod_%s_ui` but `mod_%s_server` isn't referenced in `mod_%s_server`'", 
        mod, mod_name, mod, mod_name), 
      column = col1_server))
  }
  
  merged_data <- merge(
    server_calls_data[c("mod", "module_chr", "line1", "col1", "ui_id")],
    ui_calls_data[c("mod", "fun_chr", "line1", "col1", "ui_id")],
    by = "ui_id", 
    all = TRUE, 
    suffixes = c("_server", "_ui"))
  
  ui_id_server_only_markers <- if(anyNA(merged_data$line1_uid)) {
    with(subset(merged_data, is.na(line1_uid)), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1_server, 
      message = sprintf(
        "In 'mod_%s' is referenced in `mod_%s_server` but not in `mod_%s_ui`'",
        ui_id, mod_name, mod_name),
      column = col1_server ))
  }
  
  ui_id_ui_only_markers <- if(anyNA(merged_data$line1_server )) {
    with(subset(merged_data, is.na(line1_server)), data.frame(
      type = "warning", 
      file = file_name, 
      line = line1_ui, 
      message = sprintf(
        "In 'mod_%s' is referenced in `mod_%s_ui` but not in `mod_%s_server`'",
        ui_id, mod_name, mod_name), 
      column = col1_ui))
  }
  
  rbind(
    mod_server_only_markers, 
    mod_ui_only_markers,
    ui_id_server_only_markers,
    ui_id_ui_only_markers)
}