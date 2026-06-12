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

test_that("use_external_*_file replaces existing files when replace = TRUE", {
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			utils_download_file = function(url, there) {
				file.create(there)
			},
			{
				funs_and_ext <- list(
					js = use_external_js_file,
					css = use_external_css_file,
					html = use_external_html_template,
					txt = use_external_file
				)
				mapply(
					function(fun, ext) {
						url <- paste0("this.", ext)
						# First call creates the file.
						path_to_file <- fun(
							url = url,
							golem_wd = "."
						)
						expect_exists(path_to_file)
						# Default behavior: error if the file already exists.
						expect_error(
							fun(url = url, golem_wd = "."),
							"already exists"
						)
						# With replace = TRUE: no error, file is overwritten.
						expect_no_error(
							fun(
								url = url,
								golem_wd = ".",
								replace = TRUE
							)
						)
						expect_exists(path_to_file)
					},
					funs_and_ext,
					names(funs_and_ext)
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

test_that("use_external_html_template extracts bundle into named dir", {
	skip_if(Sys.which("zip") == "")
	make_bundle <- function() {
		src <- tempfile()
		dir.create(src)
		dir.create(file.path(src, "resume"))
		writeLines("<html></html>", file.path(src, "resume", "index.html"))
		zipfile <- tempfile(fileext = ".zip")
		old <- setwd(src)
		on.exit(setwd(old), add = TRUE)
		utils::zip(
			zipfile = zipfile,
			files = "resume/index.html",
			flags = "-r9Xq"
		)
		zipfile
	}

	run_quietly_in_a_dummy_golem({
		zipfile <- make_bundle()
		out <- testthat::with_mocked_bindings(
			utils_download_file = function(url, where) {
				file.copy(zipfile, where, overwrite = TRUE)
			},
			cli_progress_bar = function(...) 1,
			cli_progress_update = function(...) invisible(NULL),
			cli_progress_done = function(...) invisible(NULL),
			{
				use_external_html_template(
					url = "https://example.com/template.zip",
					golem_wd = ".",
					extract = "yes",
					delete_zip = "yes"
				)
			}
		)
		expect_equal(
			as.character(out),
			as.character(fs_path_abs("inst/app/www/resume"))
		)
		expect_true(file.exists("inst/app/www/resume/index.html"))
		expect_false(file.exists("inst/app/www/template_bundle.zip"))
	})
})

test_that("use_external_html_template keeps expected archive name when not extracted", {
	run_quietly_in_a_dummy_golem({
		archive_names <- c()
		cases <- list(
			list(name = NULL, expected = "template_bundle.zip"),
			list(name = "foo.zip", expected = "foo.zip"),
			list(name = "foo", expected = "foo_bundle.zip"),
			list(name = "foo.html", expected = "foo_bundle.zip")
		)

		for (case in cases) {
			out <- testthat::with_mocked_bindings(
				utils_download_file = function(url, where) {
					archive_names <<- c(archive_names, basename(where))
					file.create(where)
				},
				cli_progress_bar = function(...) 1,
				cli_progress_update = function(...) invisible(NULL),
				cli_progress_done = function(...) invisible(NULL),
				{
					args <- list(
						url = "https://example.com/template.zip",
						golem_wd = ".",
						extract = "no"
					)
					if (!is.null(case$name)) {
						args$name <- case$name
					}
					do.call(use_external_html_template, args)
				}
			)
			expect_equal(basename(out), case$expected)
			unlink(out, force = TRUE)
		}

		expect_equal(
			archive_names,
			vapply(cases, `[[`, character(1), "expected")
		)
	})
})

test_that("use_bundled_html replaces existing bundle dir or stale file", {
	skip_if(Sys.which("zip") == "")
	make_bundle <- function() {
		src <- tempfile()
		dir.create(src)
		dir.create(file.path(src, "resume"))
		writeLines("<html></html>", file.path(src, "resume", "index.html"))
		zipfile <- tempfile(fileext = ".zip")
		old <- setwd(src)
		on.exit(setwd(old), add = TRUE)
		utils::zip(
			zipfile = zipfile,
			files = "resume/index.html",
			flags = "-r9Xq"
		)
		zipfile
	}

	run_in_bundled_html <- function() {
		zipfile <- make_bundle()
		testthat::with_mocked_bindings(
			utils_download_file = function(url, where) {
				file.copy(zipfile, where, overwrite = TRUE)
			},
			cli_progress_bar = function(...) 1,
			cli_progress_update = function(...) invisible(NULL),
			cli_progress_done = function(...) invisible(NULL),
			{
				use_bundled_html(
					url = "https://example.com/template.zip",
					name = "resume",
					golem_wd = ".",
					extract = "yes",
					delete_zip = "yes",
					replace = TRUE
				)
			}
		)
	}

	# Case 1: existing bundle directory is removed and re-extracted.
	run_quietly_in_a_dummy_golem({
		bundle_dir <- "inst/app/www/resume"
		dir.create(bundle_dir, recursive = TRUE)
		writeLines("stale", file.path(bundle_dir, "old.txt"))
		out <- run_in_bundled_html()
		expect_equal(
			as.character(out),
			as.character(fs_path_abs(bundle_dir))
		)
		expect_true(file.exists(file.path(bundle_dir, "index.html")))
		expect_false(file.exists(file.path(bundle_dir, "old.txt")))
	})

	# Case 2: stale file at the bundle path is removed before extraction.
	run_quietly_in_a_dummy_golem({
		bundle_path <- "inst/app/www/resume"
		dir.create(dirname(bundle_path), recursive = TRUE, showWarnings = FALSE)
		writeLines("stale", bundle_path)
		expect_true(file.exists(bundle_path) && !dir.exists(bundle_path))
		out <- run_in_bundled_html()
		expect_true(dir.exists(bundle_path))
		expect_true(file.exists(file.path(bundle_path, "index.html")))
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
		expect_false(file.exists("inst/app/www/template_bundle.zip"))
	})
})
