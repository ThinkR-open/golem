test_that("desc works", {
  testthat::skip_if_not_installed("desc")
  dummy_golem <- create_dummy_golem()
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
      withr::with_dir(
        dummy_golem,
        {
          testthat::with_mocked_bindings(
            usethis_proj_set = function(pkg) {
              return(TRUE)
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
                pkg_version = "0.0.0.9010",
                pkg = dummy_golem
              )
            }
          )
        }
      )
    }
  )
  expect_equal(
    as.character(
      desc::desc_get(
        "Package",
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "fakename"
  )
  expect_equal(
    as.character(
      desc::desc_get(
        "Title",
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "newtitle"
  )

  expect_equal(
    as.character(
      desc::desc_get_authors(
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "firstname lastname <name@test.com>"
  )
  expect_equal(
    as.character(
      desc::desc_get(
        "URL",
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "http://repo_url.com"
  )
  expect_equal(
    as.character(
      desc::desc_get(
        "Description",
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "Newdescription."
  )

  expect_equal(
    as.character(
      desc::desc_get_version(
        fs::path(dummy_golem, "DESCRIPTION")
      )
    ),
    "0.0.0.9010"
  )
  unlink(
    dummy_golem,
    TRUE,
    TRUE
  )
})
