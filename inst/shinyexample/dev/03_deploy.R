# Deploy a Prod-Ready, Robust Shiny Application.
# 
# 4. Test my package

devtools::test()
rhub::check_for_cran()

# 5. Deployment elements

## 5.1 If you want to deploy on RStudio related platforms
golem::add_rstudioconnect_file()
golem::add_shinyappsio_file()
golem::add_shinyserver_file()

## 5.2 If you want to deploy via a generic Dockerfile
golem::add_dockerfile()

## 5.2 If you want to deploy to ShinyProxy
golem::add_dockerfile_shinyproxy()

## 5.2 If you want to deploy to Heroku
golem::add_dockerfile_heroku()
