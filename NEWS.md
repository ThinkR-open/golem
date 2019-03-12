# golem 0.0.1.5000+

## Changes 

* The dev files are now splitted in three - start / dev / deploy

* Every function that adds a file now check if the file already exists, and ask the user if they want to overwrite it (#15)

* Every module is now named mod_x_ui / mod_x_server, for consistency.

## New funs

* Added `add_dockerfile()` creates a Dockerfile from a

## Removed

* `use_utils_prod` is now included in golem so you don't have to explicitely include them

# golem 0.0.1.0002

Last round of functions, and some documentation cleanup.

# golem 0.0.0.9000

* Moved from {shinytemplate} to {golem}

* Added a `NEWS.md` file to track changes to the package.
