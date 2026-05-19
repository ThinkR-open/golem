#' Create Files
#'
#' These functions create files inside the `inst/app` folder.
#'
#' @inheritParams add_module
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
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	with_doc_ready = TRUE,
	template = golem::js_template,
	...,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	temp_js <- tempfile(
		fileext = ".js"
	)
	write_there <- write_there_builder(
		temp_js
	)

	if (with_doc_ready) {
		write_there(
			"$( document ).ready(function() {"
		)
		template(
			path = temp_js,
			...
		)
		write_there(
			"});"
		)
	} else {
		template(
			path = temp_js,
			...
		)
	}

	use_internal_js_file(
		path = temp_js,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_js_handler <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	template = golem::js_handler_template,
	...,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	temp_js <- tempfile(
		fileext = ".js"
	)

	template(
		path = temp_js,
		...
	)

	use_internal_js_file(
		path = temp_js,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

binding_base_name <- function(name) {
	name <- sanitize_r_name(
		file_path_sans_ext(
			name
		)
	)

	stop_if(
		name == "",
		msg = "`name` must contain at least one alphanumeric character."
	)

	name
}

binding_name_parts <- function(name) {
	base_name <- binding_base_name(
		name
	)

	# Derive pascal from original name before lowercasing so that
	# "MyWidget" and "my_widget" both yield "MyWidget".
	raw <- file_path_sans_ext(
		name
	)
	raw <- gsub(
		"([a-z])([A-Z])",
		"\\1_\\2",
		raw
	)
	raw_parts <- unlist(
		strsplit(
			raw,
			"[^a-zA-Z0-9]+"
		)
	)
	raw_parts <- raw_parts[
		nzchar(
			raw_parts
		)
	]
	if (
		length(
			raw_parts
		) ==
			0
	) {
		raw_parts <- base_name
	}

	pascal <- paste0(
		toupper(
			substring(
				raw_parts,
				1,
				1
			)
		),
		substring(
			raw_parts,
			2
		),
		collapse = ""
	)

	list(
		base = base_name,
		pascal = pascal,
		file = gsub(
			"_",
			"-",
			base_name,
			fixed = TRUE
		),
		input_js = paste0(
			base_name,
			"-input"
		),
		output_js = paste0(
			base_name,
			"-output"
		),
		input_binding = paste0(
			base_name,
			"Input"
		),
		output_binding = paste0(
			base_name,
			"OutputBinding"
		),
		input_registration = paste0(
			"golem.",
			base_name,
			"Input"
		),
		output_registration = paste0(
			"golem.",
			base_name,
			"Output"
		),
		input_constructor = paste0(
			base_name,
			"Input"
		),
		update_input = paste0(
			"update",
			pascal,
			"Input"
		),
		output_constructor = paste0(
			base_name,
			"Output"
		),
		render_output = paste0(
			"render",
			pascal
		),
		input_type = base_name,
		output_type = base_name
	)
}

write_binding_r_file <- function(
	where,
	lines,
	open = FALSE
) {
	writeLines(
		lines,
		con = where
	)
	cat_created(
		where
	)
	open_or_go_to(
		where,
		open
	)
}

input_binding_r_lines <- function(parts) {
	template <- readLines(
		system.file(
			"bindings/input_binding.R",
			package = "golem"
		),
		warn = FALSE
	)
	for (nm in names(parts)) {
		template <- gsub(
			paste0(
				"{",
				nm,
				"}"
			),
			parts[[nm]],
			template,
			fixed = TRUE
		)
	}
	template
}

output_binding_r_lines <- function(parts) {
	template <- readLines(
		system.file(
			"bindings/output_binding.R",
			package = "golem"
		),
		warn = FALSE
	)
	for (nm in names(parts)) {
		template <- gsub(
			paste0(
				"{",
				nm,
				"}"
			),
			parts[[nm]],
			fixed = TRUE,
			x = template
		)
	}
	template
}

#' @export
#' @rdname add_files
add_js_input_binding <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	initialize = FALSE,
	dev = FALSE,
	events = list(
		name = c(
			"change",
			"input"
		),
		rate_policy = c(
			FALSE,
			FALSE
		)
	),
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	attempt::stop_if(
		length(
			events$name
		) ==
			0,
		msg = "At least one event is required"
	)

	attempt::stop_if(
		length(
			events$name
		) !=
			length(
				events$rate_policy
			),
		msg = "Incomplete events list"
	)

	parts <- binding_name_parts(
		name
	)
	temp_js <- tempfile(
		fileext = ".js"
	)

	write_there <- write_there_builder(
		temp_js
	)

	# If we find at least 1 event with a rate policy, we allow
	# the getRatePolicy method
	global_rate_policy <- sum(
		sapply(
			events$rate_policy,
			`[[`,
			1
		)
	) >
		0

	write_there(
		sprintf(
			"var %s = new Shiny.InputBinding();",
			parts$input_binding
		)
	)
	write_there(
		sprintf(
			"$.extend(%s, {",
			parts$input_binding
		)
	)
	write_there(
		"  find: function(scope) {"
	)
	write_there(
		sprintf(
			"    return $(scope).find('[data-input-type=\"%s\"]');",
			parts$input_type
		)
	)
	write_there(
		"  },"
	)

	if (initialize) {
		write_there(
			"  initialize: function(el) {"
		)
		write_there(
			"    $(el).trigger('change');"
		)
		write_there(
			"  },"
		)
	}

	write_there(
		"  getValue: function(el) {"
	)
	if (dev) {
		write_there(
			"    console.log('Reading value from custom input binding');"
		)
	}
	write_there(
		"    return $(el).val();"
	)
	write_there(
		"  },"
	)

	write_there(
		"  setValue: function(el, value) {"
	)
	if (dev) {
		write_there(
			"    console.log('Setting custom input value', value);"
		)
	}
	write_there(
		"    $(el).val(value);"
	)
	write_there(
		"  },"
	)

	write_there(
		"  receiveMessage: function(el, data) {"
	)
	write_there(
		"    if (data.hasOwnProperty('value')) {"
	)
	write_there(
		"      this.setValue(el, data.value);"
	)
	write_there(
		"    }"
	)
	write_there(
		"    if (data.hasOwnProperty('label')) {"
	)
	write_there(
		"      $(el).prev('label').text(data.label);"
	)
	write_there(
		"    }"
	)
	write_there(
		"    $(el).trigger('change');"
	)
	if (dev) {
		write_there(
			"    console.log('Received message for custom input binding');"
		)
	}
	write_there(
		"  },"
	)

	write_there(
		"  subscribe: function(el, callback) {"
	)

	lapply(
		seq_along(
			events$name
		),
		function(
			i
		) {
			write_there(
				sprintf(
					"    $(el).on('%s.%s', function(e) {",
					events$name[i],
					parts$input_binding
				)
			)
			if (events$rate_policy[i]) {
				write_there(
					"      callback(true);"
				)
			} else {
				write_there(
					"      callback();"
				)
			}
			if (dev) {
				write_there(
					"      console.log('Custom input event fired');"
				)
			}
			write_there(
				"    });"
			)
			write_there(
				""
			)
		}
	)
	write_there(
		"  },"
	)

	if (global_rate_policy) {
		write_there(
			"  getRatePolicy: function() {"
		)
		write_there(
			"    return {"
		)
		write_there(
			"      policy: 'debounce',"
		)
		write_there(
			"      delay: 250"
		)
		write_there(
			"    };"
		)
		write_there(
			"  },"
		)
	}

	write_there(
		"  unsubscribe: function(el) {"
	)
	write_there(
		sprintf(
			"    $(el).off('.%s');",
			parts$input_binding
		)
	)
	write_there(
		"  }"
	)

	write_there(
		"});"
	)
	write_there(
		sprintf(
			"Shiny.inputBindings.register(%s, '%s');",
			parts$input_binding,
			parts$input_registration
		)
	)

	r_file <- fs_path(
		golem_wd,
		"R",
		sprintf(
			"fct_%s_input_binding.R",
			parts$base
		)
	)

	old <- setwd(
		fs_path_abs(
			golem_wd
		)
	)
	on.exit(
		setwd(
			old
		),
		add = TRUE
	)
	create_if_needed(
		"R",
		type = "directory"
	)
	check_file_exists(
		r_file
	)
	write_binding_r_file(
		r_file,
		input_binding_r_lines(
			parts
		),
		open = open
	)
	cat_document_reminder()

	use_internal_js_file(
		path = temp_js,
		name = parts$input_js,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_js_output_binding <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	parts <- binding_name_parts(
		name
	)

	temp_js <- tempfile(
		fileext = ".js"
	)

	write_there <- write_there_builder(
		temp_js
	)

	write_there(
		sprintf(
			"var %s = new Shiny.OutputBinding();",
			parts$output_binding
		)
	)
	write_there(
		sprintf(
			"$.extend(%s, {",
			parts$output_binding
		)
	)
	write_there(
		"  find: function(scope) {"
	)
	write_there(
		sprintf(
			"    return $(scope).find('[data-output-type=\"%s\"]');",
			parts$output_type
		)
	)
	write_there(
		"  },"
	)
	write_there(
		"  renderValue: function(el, data) {"
	)
	write_there(
		"    if (data && data.hasOwnProperty('value')) {"
	)
	write_there(
		"      $(el).text(data.value);"
	)
	write_there(
		"    } else {"
	)
	write_there(
		"      $(el).text('');"
	)
	write_there(
		"    }"
	)
	write_there(
		"  },"
	)
	write_there(
		"  renderError: function(el, err) {"
	)
	write_there(
		"    $(el).text(err.message);"
	)
	write_there(
		"  },"
	)
	write_there(
		"  clearError: function(el) {"
	)
	write_there(
		"    $(el).text('');"
	)
	write_there(
		"  }"
	)
	write_there(
		"});"
	)
	write_there(
		sprintf(
			"Shiny.outputBindings.register(%s, '%s');",
			parts$output_binding,
			parts$output_registration
		)
	)

	r_file <- fs_path(
		golem_wd,
		"R",
		sprintf(
			"fct_%s_output_binding.R",
			parts$base
		)
	)

	old <- setwd(
		fs_path_abs(
			golem_wd
		)
	)
	on.exit(
		setwd(
			old
		),
		add = TRUE
	)
	create_if_needed(
		"R",
		type = "directory"
	)
	check_file_exists(
		r_file
	)
	write_binding_r_file(
		r_file,
		output_binding_r_lines(
			parts
		),
		open = open
	)
	cat_document_reminder()

	use_internal_js_file(
		path = temp_js,
		name = parts$output_js,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_css_file <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	template = golem::css_template,
	...,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	temp_css <- tempfile(
		fileext = ".css"
	)
	template(
		path = temp_css,
		...
	)

	use_internal_css_file(
		path = temp_css,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_sass_file <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	template = golem::sass_template,
	...,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	temp_js <- tempfile(
		fileext = ".sass"
	)
	template(
		path = temp_js,
		...
	)

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
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)

	on.exit({
		cli_alert_success(
			"After running the compilation, the generated CSS file will be automatically linked in `golem_add_external_resources()`."
		)
	})
}

add_sass_code_to_dev_script <- function(
	dir,
	name
) {
	if (
		fs_file_exists(
			"dev/run_dev.R"
		)
	) {
		lines <- readLines(
			"dev/run_dev.R"
		)
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

		cli_alert_success(
			"Code added in run_dev.R to compile your Sass file to CSS file."
		)
	}
}

#' @export
#' @rdname add_files
#' @importFrom tools file_ext
add_empty_file <- function(
	name,
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	template = golem::empty_template,
	...,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	stop_if(
		missing(
			name
		),
		msg = "`name` is required"
	)

	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	extension <- file_ext(
		name
	)

	if (extension == "js") {
		warning(
			"We've noticed you are trying to create a .js file. \nYou may want to use `add_js_file()` in future calls."
		)
		return(
			add_js_file(
				name = name,
				golem_wd = golem_wd,
				dir = dir,
				open = open,
				template = template,
				...
			)
		)
	}
	if (extension == "css") {
		warning(
			"We've noticed you are trying to create a .css file. \nYou may want to use `add_css_file()` in future calls."
		)
		return(
			add_css_file(
				name = name,
				golem_wd = golem_wd,
				dir = dir,
				open = open,
				template = template,
				...
			)
		)
	}
	if (extension == "sass") {
		warning(
			"We've noticed you are trying to create a .sass file. \nYou may want to use `add_sass_file()` in future calls."
		)
		return(
			add_sass_file(
				name = name,
				golem_wd = golem_wd,
				dir = dir,
				open = open,
				template = template,
				...
			)
		)
	}
	if (extension == "html") {
		warning(
			"We've noticed you are trying to create a .html file. \nYou may want to use `add_html_template()` in future calls."
		)
		return(
			add_html_template(
				name = name,
				golem_wd = golem_wd,
				dir = dir,
				open = open
			)
		)
	}

	temp_file <- tempfile()
	template(
		path = temp_file,
		...
	)
	use_internal_file(
		path = temp_file,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_html_template <- function(
	name = "template.html",
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}

	temp_html <- tempfile(
		fileext = ".html"
	)
	write_there <- write_there_builder(
		temp_html
	)

	write_there(
		"<!DOCTYPE html>"
	)
	write_there(
		"<html>"
	)
	write_there(
		"  <head>"
	)
	write_there(
		sprintf(
			"    <title>%s</title>",
			get_golem_name()
		)
	)
	write_there(
		"  </head>"
	)
	write_there(
		"  <body>"
	)
	write_there(
		"    {{ body }}"
	)
	write_there(
		"  </body>"
	)
	write_there(
		"</html>"
	)
	write_there(
		""
	)

	use_internal_html_template(
		path = temp_html,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_partial_html_template <- function(
	name = "partial_template.html",
	golem_wd = get_golem_wd(),
	dir = "inst/app/www",
	open = TRUE,
	dir_create,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}
	temp_html <- tempfile(
		fileext = ".html"
	)
	write_there <- write_there_builder(
		temp_html
	)

	write_there(
		"<div>"
	)
	write_there(
		"  {{ content }}"
	)
	write_there(
		"</div>"
	)
	write_there(
		""
	)

	use_internal_html_template(
		path = temp_html,
		name = name,
		golem_wd = golem_wd,
		dir = dir,
		open = open
	)
}

#' @export
#' @rdname add_files
add_ui_server_files <- function(
	golem_wd = get_golem_wd(),
	dir = "inst/app",
	dir_create,
	pkg
) {
	warn_if_in_prod_mode()
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	if (
		!missing(
			dir_create
		)
	) {
		cli_abort_dir_create()
	}
	.Deprecated(
		msg = "This function will be deprecated in a future version of {golem}.\nPlease comment on https://github.com/ThinkR-open/golem/issues/445 if you want it to stay."
	)

	old <- setwd(
		fs_path_abs(
			golem_wd
		)
	)
	on.exit(
		setwd(
			old
		)
	)

	dir <- fs_path_abs(
		dir
	)
	check_directory_exists(
		dir
	)

	# UI
	where <- fs_path(
		dir,
		"ui.R"
	)

	if (
		!fs_file_exists(
			where
		)
	) {
		fs_file_create(
			where
		)

		write_there <- write_there_builder(
			where
		)

		pkg <- get_golem_name()

		write_there(
			sprintf(
				"%s:::app_ui()",
				pkg
			)
		)

		cat_created(
			where,
			"ui file"
		)
	} else {
		cli_alert_info(
			"UI file already exists."
		)
	}

	# server
	where <- file.path(
		dir,
		"server.R"
	)

	if (
		!fs_file_exists(
			where
		)
	) {
		fs_file_create(
			where
		)

		write_there <- write_there_builder(
			where
		)

		write_there(
			sprintf(
				"%s:::app_server",
				pkg
			)
		)
		cat_created(
			where,
			"server file"
		)
	} else {
		cli_alert_info(
			"Server file already exists."
		)
	}
}
