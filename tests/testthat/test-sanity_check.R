test_that("sanity_check works", {
	run_quietly_in_a_dummy_golem({
		write(
			"browser()",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"#TODO",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"#TOFIX",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"#BUG",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"# TODO",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"# TOFIX",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		write(
			"# BUG",
			file.path(
				".",
				"R/app.R"
			),
			append = TRUE
		)
		res <- sanity_check(
			"."
		)
		expect_true(
			nrow(
				res
			) ==
				7
		)
	})
})
