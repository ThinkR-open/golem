test_that("run_dev works", {
	expect_error(
		run_dev(
			file = tempfile(),
			golem_wd = tempdir(),
			save_all = FALSE
		)
	)
	fake_run_dev <- file.path(
		tempdir(),
		"fake_run_dev.R"
	)
	write(
		"1 + 1",
		fake_run_dev
	)
	expect_equal(
		run_dev(
			file = basename(
				fake_run_dev
			),
			golem_wd = dirname(
				fake_run_dev
			),
			save_all = FALSE
		),
		2
	)
	expect_equal(
		run_dev(
			file = basename(
				fake_run_dev
			),
			golem_wd = dirname(
				fake_run_dev
			),
			save_all = TRUE
		),
		2
	)
})
