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
