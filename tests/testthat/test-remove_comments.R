test_that("Tests remove_comments on comments", {
    with_dir(pkg, {
        comments <- c(
            "# This is a first line comment",
            "#And a second line comment",
            "## Maybe a more complicated comment"
        )
        burn_after_reading(
            file = "with_comments.R",
            exp = {
                write(
                    x = comments,
                    file = "with_comments.R",
                    append = TRUE
                )
                remove_comments("with_comments.R")
                expect_true(file.exists("with_comments.R"))
                expect_true(file.size("with_comments.R") == 0)
                expect_equal(readLines("with_comments.R"), character(0))
            }
        )
    })
})

test_that("Tests remove_comments on roxygen comments", {
    with_dir(pkg, {
        roxygen_comments <- c(
            "#' A title",
            "#'",
            "#' @param",
            "#' @return",
            "#' @examples",
            "#'"
        )
        burn_after_reading(
            file = "with_roxygen_comments.R",
            exp = {
                write(
                    x = roxygen_comments,
                    file = "with_roxygen_comments.R",
                    append = TRUE
                )
                remove_comments("with_roxygen_comments.R")
                expect_true(file.exists("with_roxygen_comments.R"))
                expect_true(file.size("with_roxygen_comments.R") > 0)
                expect_equal(
                    readLines("with_roxygen_comments.R"),
                    roxygen_comments
                )
            }
        )
    })
})
