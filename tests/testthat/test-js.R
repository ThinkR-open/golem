test_that("active_js", {
	expect_s3_class(activate_js(), "shiny.tag")
})

test_that("activate_js includes the golem js file", {
	res <- activate_js()
	expect_true(
		grepl(
			"golem-js.js",
			as.character(res)
		)
	)
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

test_that("invoke_js with empty fun string throws an error", {
	expect_error(
		invoke_js(
			"",
			session = shiny::MockShinySession$new()
		)
	)
})

test_that("invoke_js sends multiple messages", {
	session <- shiny::MockShinySession$new()
	res <- invoke_js(
		"alert",
		"message one",
		"message two",
		session = session
	)
	expect_equal(
		length(res),
		2L
	)
})
