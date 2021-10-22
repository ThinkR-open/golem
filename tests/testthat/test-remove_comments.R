test_that("Tests remove_comments on comments", {
    comments <- c(
        "# This is a first line comment",
        "#And a second line comment",
        "## Maybe a more complicated comment"
    )

    temp_wih_comments <- tempfile(fileext = ".R")
    write(
        x = comments,
        file = temp_wih_comments,
        append = TRUE
    )
    remove_comments(temp_wih_comments)
    expect_true(file.exists(temp_wih_comments))
    expect_true(file.size(temp_wih_comments) == 0)
    expect_equal(readLines(temp_wih_comments), character(0))
})

test_that("Tests remove_comments on roxygen comments", {
    roxygen_comments <- c(
        "#' A title",
        "#'",
        "#' @param",
        "#' @return",
        "#' @examples",
        "#'"
    )

    temp_wih_roxygen_comments <- tempfile(fileext = ".R")
    write(
        x = roxygen_comments,
        file = temp_wih_roxygen_comments,
        append = TRUE
    )
    remove_comments(temp_wih_roxygen_comments)
    expect_true(file.exists(temp_wih_roxygen_comments))
    expect_true(file.size(temp_wih_roxygen_comments) > 0)
    expect_equal(readLines(temp_wih_roxygen_comments), roxygen_comments)
})
