test_that("desc works", {
	testthat::skip_if_not_installed("desc")
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			usethis_proj_set = function(
				pkg
			) {
				return(
					TRUE
				)
			},
			{
				fill_desc(
					pkg_name = "fakename",
					pkg_title = "newtitle",
					pkg_description = "Newdescription.",
					authors = person(
						given = "firstname",
						family = "lastname",
						email = "name@test.com"
					),
					repo_url = "http://repo_url.com",
					pkg_version = "0.0.0.9010"
				)
				expect_equal(
					as.character(
						desc::desc_get(
							"Package",
							"DESCRIPTION"
						)
					),
					"fakename"
				)
				expect_equal(
					as.character(
						desc::desc_get(
							"Title",
							"DESCRIPTION"
						)
					),
					"newtitle"
				)

				expect_equal(
					as.character(
						desc::desc_get_authors(
							"DESCRIPTION"
						)
					),
					"firstname lastname <name@test.com>"
				)
				expect_equal(
					as.character(
						desc::desc_get(
							"URL",
							"DESCRIPTION"
						)
					),
					"http://repo_url.com"
				)
				expect_equal(
					as.character(
						desc::desc_get(
							"Description",
							"DESCRIPTION"
						)
					),
					"Newdescription."
				)

				expect_equal(
					as.character(
						desc::desc_get_version(
							"DESCRIPTION"
						)
					),
					"0.0.0.9010"
				)
			}
		)
	})
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			usethis_proj_set = function(
				pkg
			) {
				return(
					TRUE
				)
			},
			{
				expect_warning(
					fill_desc(
						pkg_name = "fakename",
						pkg_title = "newtitle",
						pkg_description = "Newdescription.",
						author_first_name = list(
							"Coucou"
						),
						repo_url = "http://repo_url.com",
						pkg_version = "0.0.0.9010"
					)
				)
			}
		)
	})
	run_quietly_in_a_dummy_golem({
		testthat::with_mocked_bindings(
			usethis_proj_set = function(
				pkg
			) {
				return(
					TRUE
				)
			},
			{
				expect_warning(
					fill_desc(
						pkg_name = "fakename",
						pkg_title = "newtitle",
						pkg_description = "Newdescription.",
						author_first_name = list(
							"Coucou"
						),
						author_last_name = list(
							"Coucou"
						),
						author_email = list(
							"coucou@coucou.com"
						),
						author_orcid = NULL,
						repo_url = "http://repo_url.com",
						pkg_version = "0.0.0.9010"
					)
				)
				expect_equal(
					as.character(
						desc::desc_get_authors(
							"DESCRIPTION"
						)
					),
					"Coucou Coucou <coucou@coucou.com>"
				)
			}
		)
	})
})
