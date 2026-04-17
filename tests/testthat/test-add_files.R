test_add_file <- function(
	fun,
	file_with_extension,
	template = function(
		path,
		code = "oh no"
	) {
		write(
			code,
			file = path,
			append = TRUE
		)
	},
	with_template = TRUE,
	output_suffix = ""
) {
	file_sans_extension <- tools::file_path_sans_ext(
		file_with_extension
	)
	output <- file.path(
		"inst/app/www",
		sprintf(
			"%s%s",
			output_suffix,
			file_with_extension
		)
	)
	unlink(
		output
	)
	expect_error(
		fun()
	)
	expect_error(
		fun(
			file_sans_extension,
			open = FALSE,
			dir_create = TRUE
		)
	)
	fun(
		file_sans_extension,
		open = FALSE
	)
	expect_exists(
		output
	)
	unlink(
		output
	)
	if (with_template) {
		fun(
			sprintf(
				"tpl_%s",
				file_sans_extension
			),
			open = FALSE,
			template = template
		)
		expect_exists(
			file.path(
				"inst/app/www",
				sprintf(
					"tpl_%s",
					file_with_extension
				)
			)
		)
		all_lines <- paste0(
			readLines(
				file.path(
					"inst/app/www",
					sprintf(
						"tpl_%s",
						file_with_extension
					)
				)
			),
			collapse = " "
		)
		expect_true(
			grepl(
				"oh no",
				all_lines
			)
		)
		unlink(
			output
		)
	}
}

expect_file_contains <- function(
	path,
	text
) {
	expect_true(
		grepl(
			text,
			paste(
				readLines(
					path,
					warn = FALSE
				),
				collapse = "\n"
			),
			fixed = TRUE
		),
		info = sprintf(
			"Expected to find '%s' in %s",
			text,
			path
		)
	)
}

test_input_binding_generation <- function(name = "custom") {
	add_js_input_binding(
		name,
		open = FALSE
	)

	js_file <- file.path(
		"inst/app/www",
		sprintf(
			"%s-input.js",
			name
		)
	)
	r_file <- file.path(
		"R",
		sprintf(
			"fct_%s_input_binding.R",
			name
		)
	)

	expect_exists(
		js_file
	)
	expect_exists(
		r_file
	)

	expect_file_contains(
		js_file,
		"[data-input-type=\"custom\"]"
	)
	expect_file_contains(
		js_file,
		"var customInput = new Shiny.InputBinding();"
	)
	expect_file_contains(
		js_file,
		"getValue: function(el)"
	)
	expect_file_contains(
		js_file,
		"setValue: function(el, value)"
	)
	expect_file_contains(
		js_file,
		"receiveMessage: function(el, data)"
	)
	expect_file_contains(
		js_file,
		"Shiny.inputBindings.register(customInput, 'golem.customInput');"
	)

	expect_file_contains(
		r_file,
		"customInput <- function(inputId, label, value = \"\", ...)"
	)
	expect_file_contains(
		r_file,
		"`data-input-type` = \"custom\""
	)
	expect_file_contains(
		r_file,
		"updateCustomInput <- function(session, inputId, label = NULL, value = NULL)"
	)
	expect_file_contains(
		r_file,
		"session$sendInputMessage(inputId, message)"
	)

	r_env <- new.env(
		parent = globalenv()
	)
	sys.source(
		r_file,
		envir = r_env
	)
	expect_true(
		is.function(
			r_env$customInput
		)
	)
	expect_true(
		is.function(
			r_env$updateCustomInput
		)
	)
	expect_s3_class(
		r_env$customInput(
			"x",
			"X"
		),
		"shiny.tag"
	)

	sent <- NULL
	mock_session <- list(
		sendInputMessage = function(
			inputId,
			message
		) {
			sent <<- list(
				inputId = inputId,
				message = message
			)
		}
	)
	r_env$updateCustomInput(
		mock_session,
		"x",
		label = "Updated",
		value = "abc"
	)
	expect_equal(
		sent$inputId,
		"x"
	)
	expect_equal(
		sent$message,
		list(
			label = "Updated",
			value = "abc"
		)
	)
}

test_output_binding_generation <- function(name = "custom") {
	add_js_output_binding(
		name,
		open = FALSE
	)

	js_file <- file.path(
		"inst/app/www",
		sprintf(
			"%s-output.js",
			name
		)
	)
	r_file <- file.path(
		"R",
		sprintf(
			"fct_%s_output_binding.R",
			name
		)
	)

	expect_exists(
		js_file
	)
	expect_exists(
		r_file
	)

	expect_file_contains(
		js_file,
		"[data-output-type=\"custom\"]"
	)
	expect_file_contains(
		js_file,
		"var customOutputBinding = new Shiny.OutputBinding();"
	)
	expect_file_contains(
		js_file,
		"renderValue: function(el, data)"
	)
	expect_file_contains(
		js_file,
		"renderError: function(el, err)"
	)
	expect_file_contains(
		js_file,
		"clearError: function(el)"
	)
	expect_file_contains(
		js_file,
		"Shiny.outputBindings.register(customOutputBinding, 'golem.customOutput');"
	)

	expect_file_contains(
		r_file,
		"customOutput <- function(outputId, ...)"
	)
	expect_file_contains(
		r_file,
		"`data-output-type` = \"custom\""
	)
	expect_file_contains(
		r_file,
		"renderCustom <- function(expr, env = parent.frame(), quoted = FALSE, outputArgs = list())"
	)
	expect_file_contains(
		r_file,
		"shiny::createRenderFunction("
	)
	expect_file_contains(
		r_file,
		"outputFunc = customOutput"
	)

	r_env <- new.env(
		parent = globalenv()
	)
	sys.source(
		r_file,
		envir = r_env
	)
	expect_true(
		is.function(
			r_env$customOutput
		)
	)
	expect_true(
		is.function(
			r_env$renderCustom
		)
	)
	expect_s3_class(
		r_env$customOutput(
			"x"
		),
		"shiny.tag"
	)
	renderer <- r_env$renderCustom(
		quote("abc"),
		quoted = TRUE
	)
	expect_true(
		is.function(
			renderer
		)
	)
}

test_that("add_file works", {
	run_quietly_in_a_dummy_golem({
		test_add_file(
			add_js_file,
			"add_js_file.js"
		)
		test_add_file(
			add_js_handler,
			"add_js_handler.js"
		)

		test_input_binding_generation()
		test_output_binding_generation()

		test_add_file(
			add_css_file,
			"add_css_file.css"
		)

		test_add_file(
			add_sass_file,
			"add_sass_file.sass"
		)

		test_add_file(
			add_empty_file,
			"add_empty_file"
		)

		add_html_template(
			open = FALSE
		)

		expect_exists(
			file.path(
				"inst/app/www",
				"template.html"
			)
		)

		add_partial_html_template(
			open = FALSE
		)

		expect_exists(
			file.path(
				"inst/app/www",
				"partial_template.html"
			)
		)

		for (file in c(
			"warn_add_js_file.js",
			"warn_add_css_file.css",
			"warn_add_sass_file.sass",
			"warn_template.html"
		)) {
			expect_warning(
				add_empty_file(
					file,
					open = FALSE
				)
			)
		}
		res <- expect_warning(
			add_ui_server_files(
				golem_wd = "."
			)
		)
		expect_exists(
			"inst/app/ui.R"
		)
		expect_exists(
			"inst/app/server.R"
		)
		res <- expect_warning(
			add_ui_server_files(
				golem_wd = "."
			)
		)
	})
})

test_that("add_empty_file throws a warning if using an extension that is already handled by another function", {
	run_quietly_in_a_dummy_golem({
		for (fle in c(
			"add_js_file.js",
			"add_css_file.css",
			"add_sass_file.sass",
			"template.html"
		)) {
			expect_warning(
				add_empty_file(
					fle,
					open = FALSE
				)
			)
		}
	})
})
