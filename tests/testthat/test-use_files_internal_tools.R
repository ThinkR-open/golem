test_that("copy_internal_file works", {
	testthat::expect_snapshot({
		testthat::with_mocked_bindings(
			copy_internal_file = function(
				path,
				where
			) {
				print(
					path
				)
				print(
					where
				)
			},
			{
				copy_internal_file(
					"~/here/this.css",
					"inst/app/this.css"
				)
			}
		)
	})
})

test_that("check_url_has_the_correct_extension(url, where) works", {
	testthat::expect_snapshot(
		error = TRUE,
		{
			check_file_has_the_correct_extension(
				"https://www.google.com",
				"js"
			)
		}
	)
	expect_error({
		check_file_has_the_correct_extension(
			"https://www.google.com",
			"js"
		)
	})
	testthat::expect_null(
		check_file_has_the_correct_extension(
			"https://www.google.com/test.js",
			"js"
		)
	)
})
