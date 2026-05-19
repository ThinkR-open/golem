test_that("test app_dev", {
	withr::with_options(
		c(
			golem.app.prod = TRUE
		),
		{
			expect_false(
				app_dev()
			)
			expect_true(
				app_prod()
			)
		}
	)
	withr::with_options(
		c(
			golem.app.prod = FALSE
		),
		{
			expect_true(
				app_dev()
			)
			expect_false(
				app_prod()
			)
		}
	)
})

test_that("test print_dev", {
	withr::with_options(
		c(
			golem.app.prod = FALSE
		),
		{
			res <- capture.output({
				print_dev(
					"test"
				)
			})
			expect_true(
				grepl(
					"test",
					res
				)
			)
		}
	)
})

test_that("test make_dev", {
	withr::with_options(
		c(
			golem.app.prod = FALSE
		),
		{
			sum_dev <- make_dev(
				sum
			)
			class(
				sum_dev
			)
			expect_equal(
				sum_dev(
					1,
					2
				),
				3
			)
			expect_type(
				sum_dev(
					1,
					2
				),
				"double"
			)
			expect_type(
				sum_dev,
				"closure"
			)
		}
	)
})

test_that("warn_if_in_prod_mode warns only when golem.app.prod is TRUE", {
	withr::with_options(
		c(golem.app.prod = TRUE),
		{
			caller <- function() warn_if_in_prod_mode()
			expect_warning(
				caller(),
				"`caller\\(\\)` is a development function"
			)
		}
	)
	withr::with_options(
		c(golem.app.prod = FALSE),
		{
			caller <- function() warn_if_in_prod_mode()
			expect_no_warning(caller())
		}
	)
	withr::with_options(
		c(golem.app.prod = NULL),
		{
			caller <- function() warn_if_in_prod_mode()
			expect_no_warning(caller())
		}
	)
})

test_that("warn_if_in_prod_mode preserves the caller name for `pkg::fun` calls", {
	withr::with_options(
		c(golem.app.prod = TRUE),
		{
			# The real body errors out further down (no real golem project
			# under the tempdir); we only care about the warning text.
			expect_warning(
				try(
					golem::use_external_file(
						url = "http://example.com/x.txt",
						golem_wd = withr::local_tempdir()
					),
					silent = TRUE
				),
				"`golem::use_external_file\\(\\)` is a development function"
			)
		}
	)
})

test_that("dev scaffolding functions warn when called in prod mode", {
	# Representative samples from each in-scope family. We don't run the
	# real bodies — we only assert that the prod-mode warning fires at the
	# entry of the function. Each call runs against an isolated tempdir so
	# we don't leak files between tests.
	check_warns <- function(expr) {
		withr::with_options(
			c(golem.app.prod = TRUE),
			expect_warning(
				suppressMessages(try(expr, silent = TRUE)),
				"development function"
			)
		)
	}
	check_warns(use_external_file(
		url = "http://example.com/x.txt",
		golem_wd = withr::local_tempdir()
	))
	check_warns(add_module(
		name = "foo",
		golem_wd = withr::local_tempdir(),
		open = FALSE
	))
	check_warns(set_golem_name(
		name = "foo",
		golem_wd = withr::local_tempdir()
	))
})

test_that("test browser_button", {
	withr::with_options(
		c("golem.quiet" = FALSE),
		{
			expect_warning(
				output <- capture_output_lines(
					browser_button()
				),
				"browser_button\\(\\) is currently soft deprecated"
			)
		}
	)
	expect_true(
		grepl(
			'actionButton\\("browser", "browser"\\)',
			output[2]
		)
	)
	expect_true(
		grepl(
			'tags\\$script\\(\"\\$\\(\'#browser\'\\).hide\\(\\);\"\\)',
			output[3]
		)
	)
	expect_true(
		grepl(
			"observeEvent\\(input\\$browser",
			output[6]
		)
	)
	expect_true(
		grepl(
			"  browser()",
			output[7]
		)
	)
	expect_true(
		grepl(
			"run \\$\\('#browser'\\)\\.show\\(\\);",
			output[12]
		)
	)
})
