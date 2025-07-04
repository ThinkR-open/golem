#' Create a module
#'
#' This function creates a module inside the `R/` folder, based
#' on a specific module structure. This function can be used outside
#' of a `{golem}` project.
#'
#' @param name The name of the module.
#' @param golem_wd Path to the root of the package. Default is `get_golem_wd()`.
#' @param open Should the created file be opened?
#' @param dir_create Creates the directory if it doesn't exist, default is `TRUE`.
#' @param fct If specified, creates a `mod_fct` file.
#' @param utils If specified, creates a `mod_utils` file.
#' @param r6 If specified, creates a `mod_class` file.
#' @param js,js_handler If specified, creates a module related JavaScript file.
#' @param export Should the module be exported? Default is `FALSE`.
#' @param module_template Function that serves as a module template.
#' @param with_test should the module be created with tests?
#' @param ... Arguments to be passed to the `module_template` function.
#' @param pkg Deprecated, please use golem_wd instead
#'
#' @note This function will prefix the `name` argument with `mod_`.
#'
#' @export
#' @importFrom utils file.edit
#'
#' @seealso [module_template()]
#'
#' @return The path to the file, invisibly.
add_module <- function(
	name,
	golem_wd = get_golem_wd(),
	open = TRUE,
	dir_create = TRUE,
	fct = NULL,
	utils = NULL,
	r6 = NULL,
	js = NULL,
	js_handler = NULL,
	export = FALSE,
	module_template = golem::module_template,
	with_test = FALSE,
	...,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	# Let's start with the checks for the validity of the name
	check_name_length_is_one(
		name
	)
	check_name_syntax(
		name
	)

	# We now check that:
	# - The file name has no "mod_" prefix
	# - The file name has no extension
	name <- mod_remove(
		file_path_sans_ext(
			name
		)
	)

	# Performing the creation inside the pkg root
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

	# The module creation only works if the R folder
	# is there
	dir_created <- create_if_needed(
		fs_path(
			golem_wd,
			"R"
		),
		type = "directory"
	)

	if (!dir_created) {
		cat_dir_necessary()
		return(
			invisible(
				FALSE
			)
		)
	}

	# Now we build the correct module file name
	where <- fs_path(
		"R",
		paste0(
			"mod_",
			name,
			".R"
		)
	)

	# If the file doesn't exist, we create it
	if (
		!fs_file_exists(
			where
		)
	) {
		fs_file_create(
			where
		)

		module_template(
			name = name,
			path = where,
			export = export,
			...
		)

		cat_created(
			where
		)
		open_or_go_to(
			where,
			open
		)
	} else {
		file_already_there_dance(
			where = where,
			open_file = open
		)
	}

	# Creating all the files that come with the module
	if (
		!is.null(
			fct
		)
	) {
		add_fct(
			fct,
			module = name,
			open = open
		)
	}

	if (
		!is.null(
			utils
		)
	) {
		add_utils(
			utils,
			module = name,
			open = open
		)
	}

	if (
		!is.null(
			js
		)
	) {
		add_js_file(
			js,
			golem_wd = golem_wd,
			open = open
		)
	}

	if (
		!is.null(
			js_handler
		)
	) {
		add_js_handler(
			js_handler,
			golem_wd = golem_wd,
			open = open
		)
	}

	if (
		!is.null(
			r6
		)
	) {
		add_r6(
			r6,
			module = name,
			golem_wd = golem_wd,
			open = open
		)
	}

	if (with_test) {
		use_module_test(
			name = name,
			golem_wd = golem_wd,
			open = open
		)
	}
}

#' Golem Module Template Function
#'
#' Module template can be used to extend golem module creation
#' mechanism with your own template, so that you can be even more
#' productive when building your `{shiny}` app.
#' Module template functions do not aim at being called as is by
#' users, but to be passed as an argument to the `add_module()`
#' function.
#'
#' Module template functions are a way to define your own template
#' function for module. A template function that can take the following
#' arguments to be passed from `add_module()`:
#' + name: the name of the module
#' + path: the path to the file in R/
#' + export: a TRUE/FALSE set by the `export` param of `add_module()`
#'
#' If you want your function to ignore these parameters, set `...` as the
#' last argument of your function, then these will be ignored. See the examples
#' section of this help.
#'
#' @examples
#'
#' if (interactive()) {
#'   my_tmpl <- function(name, path, ...) {
#'     # Define a template that write to the
#'     # module file
#'     write(name, path)
#'   }
#'   golem::add_module(name = "custom", module_template = my_tmpl)
#'
#'   my_other_tmpl <- function(name, path, ...) {
#'     # Copy and paste a file from somewhere
#'     file.copy(..., path)
#'   }
#'   golem::add_module(name = "custom", module_template = my_other_tmpl)
#' }
#' @inheritParams add_module
#' @param path The path to the R script where the module will be written.
#' Note that this path will not be set by the user but via
#' `add_module()`.
#' @param ph_ui,ph_server Texts to insert inside the modules UI and server.
#'     For advanced use.
#'
#' @return Used for side effect
#' @export
#' @seealso [add_module()]
module_template <- function(
	name,
	path,
	export,
	ph_ui = " ",
	ph_server = " ",
	...
) {
	write_there <- write_there_builder(
		path
	)

	write_there(
		sprintf(
			"#' %s UI Function",
			name
		)
	)
	write_there(
		"#'"
	)
	write_there(
		"#' @description A shiny Module."
	)
	write_there(
		"#'"
	)
	write_there(
		"#' @param id,input,output,session Internal parameters for {shiny}."
	)
	write_there(
		"#'"
	)
	if (export) {
		write_there(
			sprintf(
				"#' @rdname mod_%s",
				name
			)
		)
		write_there(
			"#' @export "
		)
	} else {
		write_there(
			"#' @noRd "
		)
	}
	write_there(
		"#'"
	)
	write_there(
		"#' @importFrom shiny NS tagList "
	)
	write_there(
		sprintf(
			"mod_%s_ui <- function(id) {",
			name
		)
	)
	write_there(
		"  ns <- NS(id)"
	)
	write_there(
		"  tagList("
	)
	write_there(
		ph_ui
	)
	write_there(
		"  )"
	)
	write_there(
		"}"
	)
	write_there(
		"    "
	)

	if (
		utils::packageVersion(
			"shiny"
		) <
			"1.5"
	) {
		write_there(
			sprintf(
				"#' %s Server Function",
				name
			)
		)
		write_there(
			"#'"
		)
		if (export) {
			write_there(
				sprintf(
					"#' @rdname mod_%s",
					name
				)
			)
			write_there(
				"#' @export "
			)
		} else {
			write_there(
				"#' @noRd "
			)
		}
		write_there(
			sprintf(
				"mod_%s_server <- function(input, output, session) {",
				name
			)
		)
		write_there(
			"  ns <- session$ns"
		)
		write_there(
			ph_server
		)
		write_there(
			"}"
		)
		write_there(
			"    "
		)

		write_there(
			"## To be copied in the UI"
		)
		write_there(
			sprintf(
				'# mod_%s_ui("%s_1")',
				name,
				name
			)
		)
		write_there(
			"    "
		)
		write_there(
			"## To be copied in the server"
		)
		write_there(
			sprintf(
				'# callModule(mod_%s_server, "%s_1")',
				name,
				name
			)
		)
	} else {
		write_there(
			sprintf(
				"#' %s Server Functions",
				name
			)
		)
		write_there(
			"#'"
		)
		if (export) {
			write_there(
				sprintf(
					"#' @rdname mod_%s",
					name
				)
			)
			write_there(
				"#' @export "
			)
		} else {
			write_there(
				"#' @noRd "
			)
		}
		write_there(
			sprintf(
				"mod_%s_server <- function(id){",
				name
			)
		)
		write_there(
			"  moduleServer(id, function(input, output, session){"
		)
		write_there(
			"    ns <- session$ns"
		)
		write_there(
			ph_server
		)
		write_there(
			"  })"
		)
		write_there(
			"}"
		)
		write_there(
			"    "
		)

		write_there(
			"## To be copied in the UI"
		)
		write_there(
			sprintf(
				'# mod_%s_ui("%s_1")',
				name,
				name
			)
		)
		write_there(
			"    "
		)
		write_there(
			"## To be copied in the server"
		)
		write_there(
			sprintf(
				'# mod_%s_server("%s_1")',
				name,
				name
			)
		)
	}
}

#' Add a test file for a module
#'
#' Add a test file for in module, with the new testServer structure.
#'
#' @inheritParams add_module
#'
#' @return Used for side effect. Returns the path invisibly.
#' @export
use_module_test <- function(
	name,
	golem_wd = get_golem_wd(),
	open = TRUE,
	pkg
) {
	signal_arg_is_deprecated(
		pkg,
		fun = as.character(
			sys.call()[[1]]
		),
		"pkg"
	)
	# Remove the extension if any
	name <- file_path_sans_ext(
		name
	)
	# Remove the "mod_" if any
	name <- mod_remove(
		name
	)

	if (
		!is_existing_module(
			name,
			golem_wd = golem_wd
		)
	) {
		stop(
			sprintf(
				"The module '%s' does not exist.\nYou can call `golem::add_module('%s')` to create it.",
				name,
				name
			),
			call. = FALSE
		)
	}

	# We need testthat
	rlang::check_installed(
		"testthat",
		"to build the test structure."
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

	if (
		!fs_dir_exists(
			fs_path(
				golem_wd,
				"tests",
				"testthat"
			)
		)
	) {
		usethis_use_testthat()
	}

	path <- fs_path(
		golem_wd,
		"tests",
		"testthat",
		sprintf(
			"test-mod_%s",
			name
		),
		ext = "R"
	)

	if (
		!fs_file_exists(
			path
		)
	) {
		fs_file_create(
			path
		)

		write_there <- write_there_builder(
			path
		)

		write_there(
			"testServer("
		)
		write_there(
			sprintf(
				"  mod_%s_server,",
				name
			)
		)
		write_there(
			"  # Add here your module params"
		)
		write_there(
			"  args = list()"
		)
		write_there(
			"  , {"
		)
		write_there(
			"    ns <- session$ns"
		)
		write_there(
			"    expect_true("
		)
		write_there(
			"      inherits(ns, \"function\")"
		)
		write_there(
			"    )"
		)
		write_there(
			"    expect_true("
		)
		write_there(
			"      grepl(id, ns(\"\"))"
		)
		write_there(
			"    )"
		)
		write_there(
			"    expect_true("
		)
		write_there(
			"      grepl(\"test\", ns(\"test\"))"
		)
		write_there(
			"    )"
		)
		write_there(
			"    # Here are some examples of tests you can
    # run on your module
    # - Testing the setting of inputs
    # session$setInputs(x = 1)
    # expect_true(input$x == 1)
    # - If ever your input updates a reactiveValues
    # - Note that this reactiveValues must be passed
    # - to the testServer function via args = list()
    # expect_true(r$x == 1)
    # - Testing output
    # expect_true(inherits(output$tbl$html, \"html\"))"
		)
		write_there(
			"})"
		)
		write_there(
			" "
		)
		write_there(
			"test_that(\"module ui works\", {"
		)
		write_there(
			sprintf(
				"  ui <- mod_%s_ui(id = \"test\")",
				name
			)
		)
		write_there(
			"  golem::expect_shinytaglist(ui)"
		)
		write_there(
			"  # Check that formals have not been removed"
		)
		write_there(
			sprintf(
				"  fmls <- formals(mod_%s_ui)",
				name
			)
		)
		write_there(
			"  for (i in c(\"id\")){"
		)
		write_there(
			"    expect_true(i %in% names(fmls))"
		)
		write_there(
			"  }"
		)
		write_there(
			"})"
		)
		write_there(
			" "
		)

		cat_created(
			path
		)
	} else {
		file_already_there_dance(
			where = path,
			open_file = open
		)
	}

	open_or_go_to(
		path,
		open
	)
}

mod_remove <- function(
	string
) {
	while (
		grepl(
			"^mod_",
			string
		)
	) {
		string <- gsub(
			"^mod_",
			"",
			string
		)
	}
	string
}
