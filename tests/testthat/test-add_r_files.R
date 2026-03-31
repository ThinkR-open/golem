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

test_that("add_r6 creates a class_ file", {
	run_quietly_in_a_dummy_golem({
		add_r6(
			"myclass",
			open = FALSE
		)
		expect_exists(
			file.path(
				"R",
				"class_myclass.R"
			)
		)
		file_content <- readLines(
			file.path(
				"R",
				"class_myclass.R"
			)
		)
		expect_true(
			any(grepl(
				"R6::R6Class",
				file_content,
				fixed = TRUE
			))
		)
		expect_true(
			any(grepl(
				"myclass",
				file_content,
				fixed = TRUE
			))
		)
	})
})

test_that("append_roxygen_comment writes correct boilerplate for fct", {
	tmp <- tempfile(fileext = ".R")
	file.create(tmp)
	append_roxygen_comment(
		name = "my_fun",
		path = tmp,
		ext = "fct"
	)
	content <- readLines(tmp)
	expect_true(any(grepl("@description A fct function", content, fixed = TRUE)))
	expect_true(any(grepl("my_fun <- function", content, fixed = TRUE)))
	expect_true(any(grepl("@noRd", content, fixed = TRUE)))
	unlink(tmp)
})

test_that("append_roxygen_comment writes correct boilerplate for utils", {
	tmp <- tempfile(fileext = ".R")
	file.create(tmp)
	append_roxygen_comment(
		name = "my_util",
		path = tmp,
		ext = "utils"
	)
	content <- readLines(tmp)
	expect_true(any(grepl("@description A utils function", content, fixed = TRUE)))
	expect_true(any(grepl("utility", content, fixed = TRUE)))
	unlink(tmp)
})

test_that("append_roxygen_comment writes R6 boilerplate for class", {
	tmp <- tempfile(fileext = ".R")
	file.create(tmp)
	append_roxygen_comment(
		name = "MyClass",
		path = tmp,
		ext = "class"
	)
	content <- readLines(tmp)
	expect_true(any(grepl("R6::R6Class", content, fixed = TRUE)))
	expect_true(any(grepl("MyClass", content, fixed = TRUE)))
	unlink(tmp)
})
