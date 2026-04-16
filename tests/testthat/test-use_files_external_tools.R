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

test_that("unzip_bundled_html(from, to) works", {
	skip_if(Sys.which("zip") == "")
	src <- tempfile()
	dir.create(src)
	dir.create(file.path(src, "bundle"))
	writeLines("<html></html>", file.path(src, "bundle", "index.html"))
	zipfile <- tempfile(fileext = ".zip")
	old <- setwd(src)
	on.exit(setwd(old), add = TRUE)
	utils::zip(
		zipfile = zipfile,
		files = "bundle/index.html"
	)
	dest <- file.path(tempdir(), "bundle-unzip-dest")
	unlink(dest, recursive = TRUE, force = TRUE)
	dir.create(dest)
	msg <- testthat::capture_messages({
		unzip_bundled_html(zipfile, dest)
	})
	expect_true(any(grepl("Unzipping file", msg)))
	expect_true(any(grepl("Bundle unzipped to", msg)))
	expect_true(file.exists(file.path(dest, "bundle", "index.html")))
})

test_that("check_if_html_bundle(url) works", {
	expect_true(
		check_if_html_bundle(
			"https://example.com/template.zip"
		)
	)
	expect_true(
		check_if_html_bundle(
			"https://example.com/template.zip?download=1"
		)
	)
	expect_false(
		check_if_html_bundle(
			"https://example.com/template.html"
		)
	)
})
