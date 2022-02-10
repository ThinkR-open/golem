# Check that every file has a proper EOF
# Given that reading a file with improper EOF
# Throws a warning, we'll expect_silent() the readLines()
with_dir(pkg, {
  r_files <- list.files(pattern = ".*R$", recursive = TRUE, full.names = TRUE)

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
})
