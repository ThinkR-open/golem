test_that("add_github_action works in a fresh golem", {
	run_quietly_in_a_dummy_golem({
		add_github_action(
			golem_wd = ".",
			open = FALSE
		)

		expect_exists(".github/workflows/shiny-deploy.yaml")
		expect_exists("app.R")
		expect_exists(".rscignore")
		expect_false(file.exists("manifest.json"))
		expect_exists(".github/.gitignore")

		workflow <- readLines(
			".github/workflows/shiny-deploy.yaml",
			warn = FALSE
		)

		expect_true(
			any(
				grepl(
					"setup-renv@v2",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"hashFiles('renv.lock') != ''",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"setup-r-dependencies@v2",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"hashFiles('renv.lock') == ''",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"any::rsconnect, local::.",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"rsconnect::writeManifest",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"^\\s*renv::snapshot\\(",
					workflow,
					perl = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					'appPrimaryDoc = "app.R"',
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"CONNECT_SERVER",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"CONNECT_API_KEY",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"rsconnect::connectApiUser",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"shinyapps.io",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"RSCONNECT_",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_equal(
			sum(
				trimws(
					workflow
				) ==
					"APPNAME: shinyexample"
			),
			1
		)
		expect_true(
			"pkgload" %in%
				desc::desc_get_deps("DESCRIPTION")$package
		)
		expect_true(
			grepl(
				"\\.github",
				paste(
					readLines(
						".Rbuildignore",
						warn = FALSE
					),
					collapse = "\n"
				)
			)
		)
		expect_false(
			"^manifest\\.json$" %in%
				readLines(
					".Rbuildignore",
					warn = FALSE
				)
		)
		expect_equal(
			readLines(
				".github/.gitignore",
				warn = FALSE
			),
			"*.html"
		)
	})
})

test_that("add_gitlab_ci works in a fresh golem", {
	run_quietly_in_a_dummy_golem({
		add_gitlab_ci(
			golem_wd = ".",
			open = FALSE
		)

		expect_exists(".gitlab-ci.yml")
		expect_exists("app.R")
		expect_exists(".rscignore")
		expect_false(file.exists("manifest.json"))

		workflow <- readLines(".gitlab-ci.yml", warn = FALSE)

		expect_true(
			any(
				grepl(
					"deploy-shiny",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"CI_DEFAULT_BRANCH",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"rsconnect",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"renv::restore",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"rsconnect::writeManifest",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"^\\s*renv::snapshot\\(",
					workflow,
					perl = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"rocker/verse:4.5.3",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"rocker/verse:latest",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"CONNECT_SERVER",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					'appPrimaryDoc = "app.R"',
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
			any(
				grepl(
					"shinyapps.io",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			"^\\.gitlab-ci\\.yml$" %in%
				readLines(
					".Rbuildignore",
					warn = FALSE
				)
		)
		expect_false(
			"^manifest\\.json$" %in%
				readLines(
					".Rbuildignore",
					warn = FALSE
				)
		)
		expect_true(
			"pkgload" %in%
				desc::desc_get_deps("DESCRIPTION")$package
		)
	})
})

test_that("add_github_action backfills .rscignore when app.R already exists", {
	run_quietly_in_a_dummy_golem({
		writeLines(
			"# pre-existing app",
			"app.R"
		)

		expect_false(file.exists(".rscignore"))

		add_github_action(golem_wd = ".", open = FALSE)

		expect_exists(".rscignore")
		expect_false(file.exists("manifest.json"))
		expect_exists(".github/workflows/shiny-deploy.yaml")
		expect_equal(readLines("app.R", warn = FALSE), "# pre-existing app")
		expect_true(
			"pkgload" %in%
				desc::desc_get_deps("DESCRIPTION")$package
		)
	})
})
