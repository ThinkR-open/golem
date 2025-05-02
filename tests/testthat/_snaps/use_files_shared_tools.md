# check_directory_exists works as expected

    Code
      check_directory_exists("inst/app/www")
    Condition
      Error:
      ! The inst/app/www directory is required but does not exist.
      
      You can create it with: dir.create('inst/app/www', recursive = TRUE)

