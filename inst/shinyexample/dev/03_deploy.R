# Building a Prod-Ready, Robust Shiny Application.
# 
# Each step is optional. 
# 

# 4. Test my package

devtools::test()
rhub::check_for_cran()

# 5. Deployment elements

## 5.1 If you want to deploy on RStudio related platforms
golem::add_rconnect_file()

## 5.2 If you want to deploy via a Dockerfile
golem::add_dockerfile()
