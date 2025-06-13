test_that("active_js", {
	expect_s3_class(activate_js(), "shiny.tag")
})

test_that("invoke_js", {
	expect_error(
		invoke_js()
	)
	expect_equal(
		invoke_js(
			"clickon",
			session = shiny::MockShinySession$new()
		),
		list()
	)
})
