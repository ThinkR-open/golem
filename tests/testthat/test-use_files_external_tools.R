test_that("check_url_has_the_correct_extension(url, where) works", {
	testthat::expect_snapshot(
		error = TRUE,
		{
			check_url_has_the_correct_extension(
				"https://www.google.com",
				"js"
			)
		}
	)
	expect_error({
		check_url_has_the_correct_extension(
			"https://www.google.com",
			"js"
		)
	})
	testthat::expect_null(
		check_url_has_the_correct_extension(
			"https://www.google.com/test.js",
			"js"
		)
	)
})


test_that("download_external(url, where) works", {
	testthat::expect_snapshot({
		testthat::with_mocked_bindings(
			utils_download_file = function(
				url,
				where
			) {
				print(
					url
				)
				print(
					where
				)
			},
			{
				download_external(
					"https://www.google.com",
					"inst/app/www/google.html"
				)
			}
		)
	})
})
