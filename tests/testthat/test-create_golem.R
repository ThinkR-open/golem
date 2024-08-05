test_that("create_golem works", {
  withr::with_options(
    c("usethis.quiet" = TRUE),
    {
     testthat::with_mocked_bindings(
      here_set_here = function(...) {
        return(TRUE)
      },
      usethis_proj_set = function(...) {
        return(NULL)
      },{
        unlink(
          file.path(
            tempdir(),
            "testcreategolem"
          ),
          TRUE,
          TRUE
        )
        created <- create_golem(
          path = file.path(
            tempdir(),
            "testcreategolem"
          ),
          open = FALSE
        )
      }
     )
    }

  )
  expect_exists(
    file.path(
      tempdir(),
      "testcreategolem"
    )
  )
  expect_exists(
    file.path(
      tempdir(),
      "testcreategolem",
      "DESCRIPTION"
    )
  )
  expect_exists(
    file.path(
      tempdir(),
      "testcreategolem",
      "R"
    )
  )

  expect_exists(
    file.path(
      tempdir(),
      "testcreategolem",
      "inst"
    )
  )
   unlink(
     file.path(
       tempdir(),
       "testcreategolem"
     ),
     TRUE,
     TRUE
   )
})
