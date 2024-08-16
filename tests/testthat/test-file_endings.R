# Check that every file has a proper EOF
# Given that reading a file with improper EOF
# Throws a warning, we'll expect_silent() the readLines()

test_that(
  "All files have a proper EOF",{
    new_golem <- perform_inside_a_new_golem(function() {
      return(getwd())
    })
    withr::with_dir(
      new_golem,
      {
        r_files <- list.files(
          pattern = ".*R$",
          recursive = TRUE,
          full.names = TRUE
        )

        for (i in r_files) {
          expect_silent(
            readLines(i)
          )
        }
        js_files <- list.files(pattern = ".*js$", recursive = TRUE)

        for (i in js_files) {
          expect_silent(
            readLines(i)
          )
        }

        css_files <- list.files(pattern = ".*css$", recursive = TRUE)

        for (i in css_files) {
          expect_silent(
            readLines(i)
          )
        }
      }
    )
    unlink(
      new_golem,
      TRUE,
      TRUE
    )
  }
)
