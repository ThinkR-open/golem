test_that("is_running", {
	expect_false(is_running())
	.golem_globals$running <- TRUE
	expect_true(
		is_running()
	)
	.golem_globals$running <- FALSE
})
