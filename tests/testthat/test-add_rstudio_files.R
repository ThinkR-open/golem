test_that("add_rstudio_files", {
	for (fun in list(
		add_positconnect_file,
		add_shinyappsio_file,
		add_shinyserver_file
	)) {
		run_quietly_in_a_dummy_golem({
			fun(
				open = FALSE
			)
			expect_exists(
				"app.R"
			)
			expect_true(
				grepl(
					"run_app",
					paste(
						readLines(
							"app.R"
						),
						collapse = " "
					)
				)
			)
		})
	}
})
