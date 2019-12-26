setwd("/tmp")
golem::create_golem( "gogolele",open = FALSE)
setwd("/tmp/gogolele/")
golem::set_golem_options()
golem::fill_desc(
  pkg_name = "gogolele", 
  pkg_title = "PKG_TITLE", 
  pkg_description = "PKG_DESC.", 
  author_first_name = "AUTHOR_FIRST", 
  author_last_name = "AUTHOR_LAST",  
  author_email = "AUTHOR@MAIL.COM",      
  repo_url = NULL 
)     
golem::set_golem_options()
usethis::use_mit_license( name = "Golem User" )  
usethis::use_readme_rmd( open = FALSE )
usethis::use_code_of_conduct()
usethis::use_lifecycle_badge( "Experimental" )
usethis::use_news_md( open = FALSE )
usethis::use_data_raw( name = "my_dataset", open = FALSE )
golem::use_recommended_tests()
golem::use_recommended_deps()
golem::use_utils_ui()
golem::use_utils_server()
devtools::test()

golem::add_module( name = "my_first_module" )
golem::add_module( name = "my_other_module" )

ui <- readLines("R/app_ui.R")
ui[12] <- 'mod_my_first_module_ui("mod_my_first_module_ui_1"),\nmod_my_other_module_ui("my_other_module_ui_1")'
write(ui, "R/app_ui.R")

srv <- readLines("R/app_server.R")
srv[3] <- 'callModule(mod_my_first_module_server, "my_first_module_ui_1")\ncallModule(mod_my_other_module_server, "my_other_module_ui_1")'
write(srv, "R/app_server.R")

usethis::use_package( "thinkr" ) 

golem::add_js_file( "script", open = FALSE)
golem::add_js_handler( "handlers", open = FALSE)
golem::add_css_file( "custom", open = FALSE)

devtools::test()
remotes::install_local()


