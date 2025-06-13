test_that("set_golem_funs works", {
	run_quietly_in_a_dummy_golem({
		current_golem_name <- pkg_name()
		new_golem_wd <- tempdir()
		current_golem_wd <- pkg_path()

		# This should only change the value in the
		# yaml config.yml
		set_golem_wd(
			new_golem_wd = new_golem_wd,
			current_golem_wd = current_golem_wd,
			talkative = FALSE
		)
		expect_equal(
			normalizePath(
				get_golem_wd()
			),
			normalizePath(
				new_golem_wd
			)
		)
		# This should change :
		# - the config file
		# - app_config.R
		# - DESCRIPTION
		# - tests/testthat.R
		# - Name in Vignettes
		set_golem_name(
			name = "testpkg",
			golem_wd = ".",
			talkative = FALSE,
			old_name = "shinyexample"
		)

		# - the config file
		expect_equal(
			get_golem_name(),
			"testpkg"
		)
		# - app_config.R
		expect_true(
			grepl(
				"testpkg",
				paste0(
					readLines(
						"R/app_config.R"
					),
					collapse = ""
				)
			)
		)
		# - DESCRIPTION
		expect_equal(
			golem::pkg_name(
				golem_wd = "."
			),
			"testpkg"
		)
		# - tests/testthat.R
		expect_true(
			grepl(
				"testpkg",
				paste0(
					readLines(
						"tests/testthat.R"
					),
					collapse = ""
				)
			)
		)
		# - Name in Vignettes
		expect_true(
			grepl(
				"testpkg",
				paste0(
					readLines(
						"vignettes/myvignette.Rmd"
					),
					collapse = ""
				)
			)
		)

		set_golem_version(
			version = "0.0.0.912",
			golem_wd = ".",
			talkative = FALSE
		)

		expect_equal(
			get_golem_version(
				golem_wd = "."
			),
			"0.0.0.912"
		)
		expect_warning({
			set_golem_wd(
				new_golem_wd = new_golem_wd,
				current_golem_wd = ".",
				talkative = FALSE,
				golem_wd = "."
			)
		})
		expect_warning({
			set_golem_wd(
				new_golem_wd = new_golem_wd,
				current_golem_wd = ".",
				talkative = FALSE,
				pkg = "."
			)
		})
	})
})
