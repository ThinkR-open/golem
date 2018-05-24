# the goal of this file is to keep track of all devtools/usethis 
# call you make for yout project

# Feel free to cherry pick what you need and add elements

# install.packages("desc")
# install.packages("devtools")
# install.packages("usethis")

# DESCRIPTION 

library(desc)
# Create and clean desc
my_desc <- description$new("DESCRIPTION")
# Set your package name
my_desc$set("Package", "shinytemplate")

#Set your name
my_desc$set("Authors@R", "person('Vincent', 'Guyader', email = 'vincent@thinkr.fr', role = c('cre', 'aut'))")

# Remove some author fields
my_desc$del("Maintainer")

# Set the version
my_desc$set_version("0.0.0.9000")

# The title of your package
my_desc$set(Title = "RStudio Project Templates for Prod-ready Shinyapps")
# The description of your package
my_desc$set(Description = "Create a prod-ready shiny app with this RStudio project template.")

# The urls
my_desc$set("URL", "https://github.com/ThinkR-open/shinytemplate")
my_desc$set("BugReports", "https://github.com/ThinkR-open/shinytemplate")
# Save everyting
my_desc$write(file = "DESCRIPTION")

# If you want to use the MIT licence, code of conduct, lifecycle badge, and README
use_mit_license(name = "ThinkR")
use_code_of_conduct()
use_lifecycle_badge("Experimental")
use_news_md()
use_readme_rmd()

# For data 
usethis::use_data_raw()

# For tests 
usethis::use_testthat()
usethis::use_test("app")

# Dependencies
usethis::use_package("shiny")
usethis::use_package("DT")
usethis::use_package("stats")
usethis::use_package("graphics")
usethis::use_package("glue")

# Reorder your DESC 

usethis::use_tidy_description()

# Vignette
usethis::use_vignette("shinytemplate")
devtools::build_vignettes()

# Codecov
usethis::use_travis()
usethis::use_appveyor()
usethis::use_coverage()

# Test with rhub
rhub::check_for_cran()

