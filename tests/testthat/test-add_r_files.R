test_that("add_fct and add_utils", {
	testthat::with_mocked_bindings(
		# This is just to bypass usethis_use_test
		usethis_use_test = function(
			name,
			...
		) {
			file.create(
				file.path(
					sprintf(
						"tests/testthat/test-%s.R",
						name
					)
				)
			)
		},
		{
			run_quietly_in_a_dummy_golem({
				add_fct(
					"ui",
					open = FALSE,
					with_test = TRUE
				)
				add_utils(
					"ui",
					open = FALSE,
					with_test = TRUE
				)

				add_module(
					"rand",
					open = FALSE,
					with_test = TRUE
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand.R"
					)
				)
				add_module(
					"rand2",
					open = FALSE,
					with_test = TRUE,
					fct = "test",
					utils = "test"
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand2.R"
					)
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand2_fct_test.R"
					)
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand2_utils_test.R"
					)
				)
				add_module(
					"rand3",
					open = FALSE,
					with_test = TRUE,
					fct = "",
					utils = ""
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand3.R"
					)
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand3_fct.R"
					)
				)
				expect_exists(
					file.path(
						"R",
						"mod_rand3_utils.R"
					)
				)
				add_fct(
					"ui",
					"rand",
					open = FALSE
				)
				add_utils(
					"ui",
					"rand",
					open = FALSE
				)
				expect_exists(
					file.path(
						"R",
						"fct_ui.R"
					)
				)

				expect_exists(
					file.path(
						"R",
						"utils_ui.R"
					)
				)
				expect_exists(
					file.path(
						"tests/testthat/test-utils_ui.R"
					)
				)
				expect_exists(
					file.path(
						"tests/testthat/test-fct_ui.R"
					)
				)

				expect_error(
					add_fct(
						c(
							"a",
							"b"
						)
					),
				)
				expect_error(
					add_utils(
						c(
							"a",
							"b"
						)
					),
				)

				expect_error(
					add_module(
						c(
							"a",
							"b"
						)
					),
				)

				# If module not yet created an error is thrown
				expect_error(
					add_fct(
						"ui",
						module = "notyetcreated",
						open = FALSE
					),
					regexp = "The module 'notyetcreated' does not exist."
				)
				expect_error(
					add_utils(
						"ui",
						module = "notyetcreated",
						open = FALSE
					),
					regexp = "The module 'notyetcreated' does not exist."
				)
			})
		}
	)
})

test_that("add_fct sanitizes names correctly", {
	run_quietly_in_a_dummy_golem({
		# Name with spaces

		add_fct(
			"ma fonction",
			open = FALSE
		)
		expect_exists(
			file.path(
				"R",
				"fct_ma_fonction.R"
			)
		)

		# Name with special characters

		add_fct(
			"my-special@function!",
			open = FALSE
		)
		expect_exists(
			file.path(
				"R",
				"fct_my_special_function.R"
			)
		)

		file_content2 <- readLines(
			file.path(
				"R",
				"fct_my_special_function.R"
			)
		)
		expect_true(
			any(grepl(
				"my_special_function <- function",
				file_content2,
				fixed = TRUE
			))
		)

		# Name starting with number

		add_fct(
			"123function",
			open = FALSE
		)
		expect_exists(
			file.path(
				"R",
				"fct_x123function.R"
			)
		)

		file_content3 <- readLines(
			file.path(
				"R",
				"fct_x123function.R"
			)
		)
		expect_true(
			any(grepl("x123function <- function", file_content3, fixed = TRUE))
		)
	})
})

test_that("fct_template works", {
	fct_template(
		"my_fun",
		path <- tempfile(),
		export = TRUE
	)
	on.exit({
		unlink(
			path,
			recursive = TRUE,
			force = TRUE
		)
	})
	fct_read <- paste(
		readLines(
			path
		),
		collapse = " "
	)
	expect_true(
		grepl(
			"my_fun <- function",
			fct_read
		)
	)
	expect_true(
		grepl(
			"@export",
			fct_read
		)
	)
})

test_that("add_fct accepts a template", {
	run_quietly_in_a_dummy_golem({
		add_fct(
			"custom",
			open = FALSE,
			template = function(
				name,
				path,
				export = FALSE,
				...
			) {
				writeLines(
					c(
						"#' custom function",
						if (export) "#' @export" else "#' @noRd",
						sprintf(
							"%s <- function() \"ok\"",
							name
						)
					),
					con = path
				)
			}
		)

		expect_exists(
			file.path(
				"R",
				"fct_custom.R"
			)
		)

		file_content <- paste(
			readLines(
				file.path(
					"R",
					"fct_custom.R"
				)
			),
			collapse = " "
		)
		expect_true(
			grepl(
				'custom <- function\\(\\) "ok"',
				file_content
			)
		)
	})
})
