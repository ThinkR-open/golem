# copy_internal_file works

    Code
      testthat::with_mocked_bindings(copy_internal_file = function(path, where) {
        print(path)
        print(where)
      }, {
        copy_internal_file("~/here/this.css", "inst/app/this.css")
      })
    Output
      [1] "~/here/this.css"
      [1] "inst/app/this.css"

# check_url_has_the_correct_extension(url, where) works

    Code
      check_file_has_the_correct_extension("https://www.google.com", "js")
    Condition
      Error:
      ! File not added (URL must end with .js extension)

