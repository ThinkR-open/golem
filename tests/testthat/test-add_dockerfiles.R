test_that("add_dockerfile* are hard deprecated", {
	expect_error(
		add_dockerfile(),
		"add_dockerfile\\(\\) is defunct"
	)
	expect_error(
		add_dockerfile_shinyproxy(),
		"add_dockerfile_shinyproxy\\(\\) is defunct"
	)
	expect_error(
		add_dockerfile_heroku(),
		"add_dockerfile_heroku\\(\\) is defunct"
	)
})
