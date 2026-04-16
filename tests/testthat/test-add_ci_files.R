test_that("add_github_action works in a fresh golem", {
	run_quietly_in_a_dummy_golem({
		add_github_action(
			golem_wd = ".",
			open = FALSE
		)

		expect_exists(
			".github/workflows/shiny-deploy.yaml"
		)
		expect_exists(
			"app.R"
		)
		expect_exists(
			".rscignore"
		)
		expect_exists(
			".github/.gitignore"
		)

		workflow <- readLines(
			".github/workflows/shiny-deploy.yaml",
			warn = FALSE
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
					"any::rsconnect, local::.",
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_false(
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
					'appPrimaryDoc = "app.R"',
					workflow,
					fixed = TRUE
				)
			)
		)
		expect_true(
			any(
				grepl(
					"RSCONNECT_USER",
					workflow,
					fixed = TRUE
				)
			)
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

		expect_exists(
			".gitlab-ci.yml"
		)
		expect_exists(
			"app.R"
		)
		expect_exists(
			".rscignore"
		)

		workflow <- readLines(
			".gitlab-ci.yml",
			warn = FALSE
		)

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
					'appPrimaryDoc = "app.R"',
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
	})
})

test_that("add_github_action backfills .rscignore when app.R already exists", {
	run_quietly_in_a_dummy_golem({
		writeLines(
			"# pre-existing app",
			"app.R"
		)

		expect_false(
			file.exists(
				".rscignore"
			)
		)

		add_github_action(
			golem_wd = ".",
			open = FALSE
		)

		expect_exists(
			".rscignore"
		)
		expect_exists(
			".github/workflows/shiny-deploy.yaml"
		)
	})
})
