is_properly_populated_golem <- function(path) {
	# All files excepts *.Rproj which changes based on the project name
	expected_files <- list.files(
		golem_sys(
			"shinyexample"
		),
		recursive = TRUE
	)
	expected_files <- expected_files[
		!grepl(
			"Rproj",
			expected_files
		)
	]
	expected_files <- expected_files[
		!grepl(
			"Rproj",
			expected_files
		)
	]

	expected_files <- expected_files[
		!grepl(
			"REMOVEME.Rbuildignore",
			expected_files
		)
	]
	expected_files <- expected_files[
		!grepl(
			"REMOVEME.Rbuildignore",
			expected_files
		)
	]

	actual_files <- list.files(
		path,
		recursive = TRUE
	)

	identical(
		sort(
			expected_files
		),
		sort(
			actual_files
		)
	)
}
test_that("create_golem works", {
	dir <- tempfile(
		pattern = "golemcreategolem"
	)
	withr::with_options(
		c(
			"usethis.quiet" = TRUE
		),
		{
			dir <- create_golem(
				dir,
				open = FALSE,
				package_name = "testpkg"
			)
		}
	)
	expect_true(
		is_properly_populated_golem(
			dir
		)
	)
	unlink(
		dir,
		TRUE,
		TRUE
	)
})

test_that("the dev files work", {
	skip_on_cran()
	dir <- tempfile(
		pattern = "golemcreategolem"
	)
	withr::with_options(
		c(
			"usethis.quiet" = TRUE
		),
		{
			testthat::with_mocked_bindings(
				open_or_go_to = function(
					...
				) {
					return(
						TRUE
					)
				},
				{
					dir <- create_golem(
						dir,
						open = FALSE,
						package_name = "testpkg"
					)
					old_dir <- setwd(
						dir
					)
					# We'll test some of the functions from dev
					one <- readLines(
						"dev/01_start.R"
					)
					one[
						grepl(
							"golem::install_dev_deps()",
							one
						)
					] <- "golem::install_dev_deps(force = TRUE)"
					one[
						grepl(
							"golem::use_recommended_tests",
							one
						)
					] <- "golem::use_recommended_tests(spellcheck = FALSE)"
					one[
						grepl(
							"usethis::use_git()",
							one,
							fixed = TRUE
						)
					] <- "# usethis::use_git()"
					one[
						grepl(
							"devtools::build_readme()",
							one,
							fixed = TRUE
						)
					] <- "# devtools::build_readme()"
					one[
						which(
							grepl(
								"use_git_remote",
								one
							)
						) +
							0:3
					] <- ''
					one[
						grepl(
							"navigateToFile",
							one
						)
					] <- "# navigateToFile"
					write(
						one,
						"dev/01_start.R"
					)
					source(
						"dev/01_start.R"
					)
					#browser()
					expect_true(
						unname(
							desc::desc_get(
								"Package"
							)
						) ==
							"testpkg"
					)
					expect_true(
						unname(
							desc::desc_get(
								"Title"
							)
						) ==
							"PKG_TITLE"
					)
					expect_true(
						unname(
							desc::desc_get(
								"Description"
							)
						) ==
							"PKG_DESC."
					)
					expect_true(
						unname(
							desc::desc_get(
								"License"
							)
						) ==
							"MIT + file LICENSE"
					)
					expect_exists(
						"README.Rmd"
					)
					expect_exists(
						"NEWS.md"
					)
					expect_exists(
						"R/golem_utils_server.R"
					)
					expect_exists(
						"R/golem_utils_ui.R"
					)
					expect_exists(
						"tests/testthat/test-golem_utils_server.R"
					)
					expect_exists(
						"tests/testthat/test-golem_utils_ui.R"
					)
					expect_exists(
						"tests/testthat/test-golem-recommended.R"
					)

					two <- readLines(
						"dev/02_dev.R"
					)
					# We'll test a subset of the vignette, as the rest is in usethis
					two <- two[
						which(
							grepl(
								"golem::add_module",
								two
							)
						)[1]:which(
							grepl(
								"use_vignette",
								two
							)
						)[1]
					]
					write(
						two,
						"dev/02_dev.R"
					)
					source(
						"dev/02_dev.R"
					)
					expect_exists(
						"R/mod_name_of_module1.R"
					)
					expect_exists(
						"tests/testthat/test-mod_name_of_module1.R"
					)
					expect_exists(
						"R/mod_name_of_module2.R"
					)
					expect_exists(
						"tests/testthat/test-mod_name_of_module2.R"
					)
					expect_exists(
						"R/fct_helpers.R"
					)
					expect_exists(
						"tests/testthat/test-fct_helpers.R"
					)
					expect_exists(
						"R/utils_helpers.R"
					)
					expect_exists(
						"tests/testthat/test-utils_helpers.R"
					)
					expect_exists(
						"inst/app/www/handlers.js"
					)
					expect_exists(
						"inst/app/www/custom.css"
					)
					expect_exists(
						"inst/app/www/custom.sass"
					)
					expect_exists(
						"inst/app/www/file.json"
					)
					expect_exists(
						"data-raw/my_dataset.R"
					)
					expect_exists(
						"tests/testthat/test-app.R"
					)
					setwd(
						old_dir
					)
				}
			)
		}
	)

	unlink(
		dir,
		TRUE,
		TRUE
	)
})


test_that("create_golem fails if the dir already exists", {
	dir <- tempfile(
		pattern = "golemcreategolemfail"
	)
	dir.create(
		dir
	)
	expect_error({
		withr::with_options(
			c(
				"usethis.quiet" = TRUE
			),
			{
				dir <- create_golem(
					dir,
					open = FALSE,
					package_name = "testpkg"
				)
			}
		)
	})

	unlink(
		dir,
		TRUE,
		TRUE
	)
})

test_that("create_golem override if the dir already exists and overwrite is set to TRUE", {
	dir <- tempfile(
		pattern = "golemcreategolemfail"
	)
	dir.create(
		dir
	)
	withr::with_options(
		c(
			"usethis.quiet" = TRUE
		),
		{
			dir <- create_golem(
				dir,
				overwrite = TRUE,
				open = FALSE,
				package_name = "testpkg"
			)
		}
	)
	expect_true(
		is_properly_populated_golem(
			dir
		)
	)
	unlink(
		dir,
		TRUE,
		TRUE
	)
})

test_that("create_golem can remove comments", {
	dir <- tempfile(
		pattern = "golemcreategolemfail"
	)

	withr::with_options(
		c(
			"usethis.quiet" = TRUE
		),
		{
			dir <- create_golem(
				dir,
				without_comments = TRUE,
				open = FALSE,
				package_name = "testpkg"
			)
		}
	)
	expect_equal(
		length(
			readLines(
				file.path(
					dir,
					"dev",
					"01_start.R"
				)
			)
		),
		31
	)
	expect_false(
		any(
			grepl(
				"^# *",
				readLines(
					file.path(
						dir,
						"dev",
						"01_start.R"
					)
				)
			)
		)
	)
	unlink(
		dir,
		TRUE,
		TRUE
	)
})

test_that("create_golem with git works", {
	dir <- tempfile(
		pattern = "golemcreategolemfail"
	)

	withr::with_options(
		c(
			"usethis.quiet" = TRUE
		),
		{
			dir <- create_golem(
				dir,
				with_git = TRUE,
				open = FALSE,
				package_name = "testpkg"
			)
		}
	)
	expect_exists(
		file.path(
			dir,
			".git"
		)
	)
	unlink(
		dir,
		TRUE,
		TRUE
	)
})

test_that("create_golem_gui works", {
	testthat::with_mocked_bindings(
		create_golem = function(
			...
		) {
			return(
				TRUE
			)
		},
		{
			expect_error(
				create_golem_gui()
			)
			expect_true(
				create_golem_gui(
					project_hook = "golem::project_hook"
				)
			)
		}
	)
})
