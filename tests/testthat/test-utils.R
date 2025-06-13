test_that("golem_sys() returns a path", {
	expect_true(
		grepl(
			"golem",
			golem_sys()
		)
	)
})

test_that("rlang_is_interactive() works", {
	expect_equal(
		rlang_is_interactive(),
		rlang::is_interactive()
	)
})

test_that("create_if_needed creates a file if required", {
	expect_error(
		testthat::with_mocked_bindings(
			rlang_is_interactive = function() {
				return(
					FALSE
				)
			},
			code = {
				create_if_needed(
					tempfile()
				)
			}
		)
	)
	expect_false(
		testthat::with_mocked_bindings(
			rlang_is_interactive = function() {
				return(
					TRUE
				)
			},
			ask_golem_creation_file = function(
				path,
				type
			) {
				return(
					FALSE
				)
			},
			code = {
				create_if_needed(
					tempfile()
				)
			}
		)
	)
	expect_true(
		testthat::with_mocked_bindings(
			rlang_is_interactive = function() {
				return(
					TRUE
				)
			},
			ask_golem_creation_file = function(path, type) {
				return(
					TRUE
				)
			},
			code = {
				create_if_needed(
					tempfile()
				)
			}
		)
	)
	expect_true(
		testthat::with_mocked_bindings(
			rlang_is_interactive = function() {
				return(
					TRUE
				)
			},
			ask_golem_creation_file = function(path, type) {
				return(
					TRUE
				)
			},
			code = {
				create_if_needed(
					tempfile(),
					type = "dir"
				)
			}
		)
	)
})

test_that("ask_golem_creation_file works", {
	expect_true(
		testthat::with_mocked_bindings(
			yesno = identity,
			{
				grepl(
					"The Kilian Jornet doesn't exist, create?",
					ask_golem_creation_file(
						"Kilian",
						"Jornet"
					)
				)
			}
		)
	)
})

test_that("replace_word works", {
	fls <- tempfile()
	write(
		"Zach Jornet",
		fls
	)
	replace_word(
		fls,
		"Zach",
		"Kilian"
	)
	expect_true(
		grepl(
			"Kilian",
			readLines(fls)
		)
	)
	unlink(fls)
})

test_that("remove_comments works", {
	fls <- tempfile()
	write(
		"Zach Miller",
		fls
	)
	write(
		"# Zach Miller",
		fls,
		append = TRUE
	)
	write(
		"Zach Miller",
		fls,
		append = TRUE
	)
	# Checking that we don't remove
	# roxygen tags
	write(
		"#' Zach Miller",
		fls,
		append = TRUE
	)
	remove_comments(
		fls
	)
	expect_true(
		length(
			readLines(
				fls
			)
		) ==
			3
	)
})

test_that("open_or_go_to works", {
	res <- testthat::capture_output_lines({
		open_or_go_to(
			"jurek",
			FALSE
		)
	})
	expect_true(
		grepl(
			"Go to jurek",
			res
		)
	)
	res <- testthat::with_mocked_bindings(
		rstudioapi_navigateToFile = function(
			...
		) {
			return(
				"Scott Jurek"
			)
		},
		{
			open_or_go_to(
				"UTMB",
				TRUE
			)
		}
	)
	expect_equal(
		res,
		"UTMB"
	)
})

test_that("desc_exist works", {
	withr::with_tempdir(
		expect_false(
			desc_exist(
				"."
			)
		)
	)
	withr::with_tempdir(
		expect_true(
			file.create(
				"DESCRIPTION"
			),
			desc_exist(
				"."
			)
		)
	)
})

test_that("if_not_null works", {
	expect_null(
		if_not_null(
			NULL,
			1 + 1
		)
	)
	expect_equal(
		if_not_null(
			TRUE,
			1 + 1
		),
		2
	)
})

test_that("set_name works", {
	expect_named(
		set_name(
			1:2,
			c(
				"a",
				"b"
			)
		),
		c(
			"a",
			"b"
		)
	)
})

test_that("file_path_sans_ext works", {
	expect_equal(
		file_path_sans_ext(
			"scott.jpg"
		),
		"scott"
	)
})

test_that("file_ext works", {
	expect_equal(
		file_ext(
			"scott.jpg"
		),
		"jpg"
	)
})

test_that("yesno works", {
	expect_true(
		testthat::with_mocked_bindings(
			utils_menu = function(
				...
			) {
				return(
					1
				)
			},
			yesno()
		)
	)
})

test_that("is_existing_module() properly detects modules if they are present", {
	dummy_golem <- create_dummy_golem()
	dummy_module_files <- c(
		"mod_main.R",
		"mod_left_pane.R",
		"mod_pouet_pouet.R"
	)
	file.create(
		file.path(
			dummy_golem,
			"R",
			dummy_module_files
		)
	)

	withr::with_dir(dummy_golem, {
		expect_false(
			is_existing_module(
				"foo"
			)
		)
		expect_true(
			is_existing_module(
				"left_pane"
			)
		)
		expect_true(
			is_existing_module(
				"main"
			)
		)
		expect_true(
			is_existing_module(
				"pouet_pouet"
			)
		)
		expect_false(
			is_existing_module(
				"plif_plif"
			)
		)
	})

	# Cleanup
	unlink(
		dummy_golem,
		TRUE,
		TRUE,
		TRUE
	)
})

test_that("is_existing_module() fails outside an R package", {
	dummy_golem <- create_dummy_golem()
	withr::with_dir(
		dummy_golem,
		{
			unlink(
				"R",
				TRUE,
				TRUE
			)
			dir.create(
				"RR/"
			)
			file.create(
				file.path(
					dummy_golem,
					"RR",
					"left_pane"
				)
			)
			expect_error(
				is_existing_module(
					"left_pane"
				),
				"Cannot be called when not inside a R-package"
			)
		}
	)

	# Cleanup
	unlink(
		dummy_golem,
		TRUE,
		TRUE,
		TRUE
	)
})

test_that("check_name_length_is_one works", {
	expect_error(
		check_name_length_is_one(
			names(
				iris
			)
		)
	)
	expect_null(
		check_name_length_is_one(
			"a"
		)
	)
})

test_that("do_if_unquiet works", {
	expect_null({
		withr::with_options(
			c(
				"golem.quiet" = TRUE
			),
			{
				do_if_unquiet(
					1 + 1
				)
			}
		)
	})
	expect_null({
		withr::with_options(
			c(
				"usethis.quiet" = TRUE
			),
			{
				do_if_unquiet(
					1 + 1
				)
			}
		)
	})
	expect_equal(
		{
			withr::with_options(
				c(
					"usethis.quiet" = FALSE
				),
				{
					do_if_unquiet(
						1 + 1
					)
				}
			)
		},
		2
	)
})

test_that("check_name_syntax throws an info", {
	res <- testthat::capture_messages({
		check_name_syntax(
			"mod_jornet"
		)
	})
	expect_true(
		grepl(
			"This is not necessary as golem will prepend 'mod_' to your module name automatically",
			paste(
				res,
				collapse = " "
			)
		)
	)
})

test_that("signal_path_is_deprecated works", {
	expect_warning(
		{
			signal_arg_is_deprecated(
				path = "plop",
				fun = "blabla"
			)
		},
		regexp = "blabla"
	)
	expect_warning(
		{
			signal_arg_is_deprecated(
				path = "plop",
				fun = "blabla"
			)
		},
		regexp = "blabla"
	)
	expect_warning(
		{
			signal_arg_is_deprecated(
				path = "plop",
				fun = "blabla",
				first_arg = "doudou"
			)
		},
		regexp = "doudou"
	)
	expect_warning(
		{
			signal_arg_is_deprecated(
				path = "plop",
				fun = "blabla",
				first_arg = "doudou",
				second_arg = "mons"
			)
		},
		regexp = "mons"
	)
})
