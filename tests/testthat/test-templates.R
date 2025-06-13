test_that("project_hook works", {
	expect_true(
		project_hook()
	)
})

test_that("js_handler_template works", {
	tpjs <- tempfile(
		fileext = ".js"
	)
	js_handler_template(
		tpjs,
		code = "Zach Miller"
	)
	expect_true(
		grepl(
			"Shiny.addCustomMessageHandler",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	expect_true(
		grepl(
			"Zach Miller",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	unlink(
		tpjs
	)
})

test_that("js_template works", {
	tpjs <- tempfile(
		fileext = ".js"
	)
	js_template(
		tpjs,
		code = "Zach Miller"
	)

	expect_true(
		grepl(
			"Zach Miller",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	unlink(
		tpjs
	)
})

test_that("js_template works", {
	tpjs <- tempfile(
		fileext = ".css"
	)
	css_template(
		tpjs,
		code = "Zach Miller"
	)

	expect_true(
		grepl(
			"Zach Miller",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	unlink(
		tpjs
	)
})

test_that("sass_template works", {
	tpjs <- tempfile(
		fileext = ".sass"
	)
	sass_template(
		tpjs,
		code = "Zach Miller"
	)

	expect_true(
		grepl(
			"Zach Miller",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	unlink(
		tpjs
	)
})


test_that("empty_template works", {
	tpjs <- tempfile(
		fileext = ".xyz"
	)
	empty_template(
		tpjs,
		code = "Zach Miller"
	)

	expect_true(
		grepl(
			"Zach Miller",
			paste(
				readLines(
					tpjs
				),
				collapse = ""
			)
		)
	)
	unlink(
		tpjs
	)
})
