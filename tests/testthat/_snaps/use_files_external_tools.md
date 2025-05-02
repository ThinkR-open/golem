# check_url_has_the_correct_extension(url, where) works

    Code
      check_url_has_the_correct_extension("https://www.google.com", "js")
    Condition
      Error:
      ! File not added (URL must end with .js extension)

# download_external(url, where) works

    Code
      testthat::with_mocked_bindings(utils_download_file = function(url, where) {
        print(url)
        print(where)
      }, {
        download_external("https://www.google.com", "inst/app/www/google.html")
      })
    Output
      
      Initiating file download
      [1] "https://www.google.com"
      [1] "inst/app/www/google.html"
      v File downloaded at inst/app/www/google.html

