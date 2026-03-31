test_that("daf_desc & pkg works", {
	run_quietly_in_a_dummy_golem({
		expect_equal(
			daf_desc(
				".",
				"Package"
			),
			"shinyexample"
		)
		expect_equal(
			pkg_name(
				"."
			),
			"shinyexample"
		)
		expect_equal(
			pkg_version(
				"."
			),
			"0.0.0.9000"
		)
		expect_equal(
			pkg_path(),
			getwd()
		)
	})
})

test_that("pkg_name returns a single character string", {
	run_quietly_in_a_dummy_golem({
		res <- pkg_name(".")
		expect_type(res, "character")
		expect_length(res, 1L)
	})
})

test_that("pkg_version returns a single character string", {
	run_quietly_in_a_dummy_golem({
		res <- pkg_version(".")
		expect_type(res, "character")
		expect_length(res, 1L)
	})
})

test_that("pkg_path returns the current working directory", {
	run_quietly_in_a_dummy_golem({
		expect_equal(
			pkg_path(),
			getwd()
		)
	})
})
