test_that("use_external_*_file works", {
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			utils_download_file = function(
				url,
				there
			) {
				file.create(
					there
				)
			},
			{
				funs_and_ext <- list(
					js = use_external_js_file,
					css = use_external_css_file,
					html = use_external_html_template,
					txt = use_external_file
				)
				mapply(
					function(
						fun,
						ext
					) {
						unlink(
							paste0(
								"this.",
								ext
							)
						)
						expect_error({
							fun(
								url = paste0(
									"this.",
									ext
								),
								golem_wd = ".",
								dir_create = TRUE
							)
						})
						path_to_file <- fun(
							url = paste0(
								"this.",
								ext
							),
							golem_wd = "."
						)
						expect_exists(
							path_to_file
						)
					},
					funs_and_ext,
					names(
						funs_and_ext
					)
				)
			}
		)
	})
})

test_that("use_internal_*_file works", {
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			fs_file_copy = function(
				url,
				where
			) {
				file.create(
					where
				)
			},
			{
				funs_and_ext <- list(
					js = use_internal_js_file,
					css = use_internal_css_file,
					html = use_internal_html_template,
					txt = use_internal_file
				)
				mapply(
					function(
						fun,
						ext
					) {
						if (ext != "txt") {
							expect_error(
								fun(
									path = "this.nop",
									golem_wd = "."
								)
							)
						}
						path_to_file <- fun(
							path = paste0(
								"this.",
								ext
							),
							golem_wd = "."
						)
						expect_exists(
							path_to_file
						)
						expect_equal(
							file_ext(
								path_to_file
							),
							ext
						)
					},
					funs_and_ext,
					names(
						funs_and_ext
					)
				)
			}
		)
	})
})

test_that("use_external_html_template downloads and extracts html bundles", {
	skip_if(Sys.which("zip") == "")
	make_bundle <- function() {
		src <- tempfile()
		dir.create(src)
		dir.create(file.path(src, "resume"))
		writeLines("<html></html>", file.path(src, "resume", "index.html"))
		zipfile <- tempfile(fileext = ".zip")
		old <- setwd(src)
		on.exit(setwd(old), add = TRUE)
		utils::zip(zipfile = zipfile, files = "resume/index.html")
		zipfile
	}

	run_quietly_in_a_dummy_golem({
		zipfile <- make_bundle()
		yesno_answers <- local({
			answers <- c(TRUE, TRUE)
			function(...) {
				answer <- answers[[1]]
				answers <<- answers[-1]
				answer
			}
		})
		out <- testthat::with_mocked_bindings(
			utils_download_file = function(url, where) {
				file.copy(zipfile, where, overwrite = TRUE)
			},
			cat_yes_no_or_cancel = function(...) "yes",
			yesno = yesno_answers,
			cli_progress_bar = function(...) 1,
			cli_progress_update = function(...) invisible(NULL),
			cli_progress_done = function(...) invisible(NULL),
			{
				use_external_html_template(
					url = "https://example.com/template.zip",
					golem_wd = "."
				)
			}
		)
		expect_equal(out, fs_path_abs("inst/app/www"))
		expect_true(file.exists("inst/app/www/resume/index.html"))
		expect_false(file.exists("inst/app/www/template.zip"))
	})
})

test_that("use_external_html_template keeps zip when not extracted", {
	run_quietly_in_a_dummy_golem({
		out <- testthat::with_mocked_bindings(
			utils_download_file = function(url, where) file.create(where),
			cli_progress_bar = function(...) 1,
			cli_progress_update = function(...) invisible(NULL),
			cli_progress_done = function(...) invisible(NULL),
			{
				use_external_html_template(
					url = "https://example.com/template.zip",
					golem_wd = ".",
					extract = "no"
				)
			}
		)
		expect_true(file.exists(out))
		expect_equal(file_ext(out), "zip")
	})
})

test_that("use_external_html_template cancels and removes downloaded zip", {
	run_quietly_in_a_dummy_golem({
		out <- testthat::with_mocked_bindings(
			utils_download_file = function(url, where) file.create(where),
			cat_yes_no_or_cancel = function(...) "cancel",
			cli_progress_bar = function(...) 1,
			cli_progress_update = function(...) invisible(NULL),
			cli_progress_done = function(...) invisible(NULL),
			{
				use_external_html_template(
					url = "https://example.com/template.zip",
					golem_wd = "."
				)
			}
		)
		expect_null(out)
		expect_false(file.exists("inst/app/www/template.zip"))
	})
})
