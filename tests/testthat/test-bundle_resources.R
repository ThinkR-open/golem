test_that("multiplication works", {
	run_quietly_in_a_dummy_golem({
		add_css_file(
			golem_wd = ".",
			"bundle",
			open = FALSE
		)
		add_js_file(
			golem_wd = ".",
			"bundle",
			open = FALSE
		)
		res <- bundle_resources(
			path = "inst/app/www",
			app_title = "fakename",
			with_sparkles = TRUE
		)
		expect_equal(
			length(
				res
			),
			3
		)
		expect_true(
			inherits(
				res[[1]],
				"html_dependency"
			)
		)
		expect_true(
			inherits(
				res[[2]],
				"shiny.tag"
			)
		)
		expect_true(
			inherits(
				res[[3]],
				"html_dependency"
			)
		)
	})
})

test_that("bundle_resources returns empty list for empty directory", {
	tmp <- tempfile()
	dir.create(tmp)
	on.exit(unlink(tmp, recursive = TRUE))
	res <- bundle_resources(
		path = tmp,
		app_title = "fakename"
	)
	expect_equal(res, list())
})

test_that("bundle_resources with_sparkles=FALSE does not add sparkles dependency", {
	run_quietly_in_a_dummy_golem({
		add_js_file(
			golem_wd = ".",
			"nobundle",
			open = FALSE
		)
		res <- bundle_resources(
			path = "inst/app/www",
			app_title = "fakename",
			with_sparkles = FALSE
		)
		classes <- vapply(res, function(x) class(x)[[1]], character(1))
		expect_false(
			any(vapply(
				res,
				function(x) {
					inherits(x, "html_dependency") && isTRUE(x$name == "sparkles")
				},
				logical(1)
			))
		)
	})
})

test_that("bundle_resources with activate_js=FALSE excludes JS injection in head", {
	run_quietly_in_a_dummy_golem({
		add_js_file(
			golem_wd = ".",
			"nojsbundle",
			open = FALSE
		)
		res_with <- bundle_resources(
			path = "inst/app/www",
			app_title = "test",
			activate_js = TRUE
		)
		res_without <- bundle_resources(
			path = "inst/app/www",
			app_title = "test",
			activate_js = FALSE
		)
		head_with <- res_with[[1]]$head
		head_without <- res_without[[1]]$head
		expect_true(
			nchar(paste(head_with, collapse = "")) > nchar(paste(head_without, collapse = ""))
		)
	})
})
