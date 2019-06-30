old <- setwd(tempdir())
golem::create_golem( 
  file.path(old, "bing"), 
  open = FALSE
)
unlink("inst/app/", TRUE)
# Should ask for dircreation creation
golem::add_css_file("plop", open = FALSE)
# Should not ask for dircreation
golem::add_css_file("pouet", open = FALSE)

unlink("inst/app/", TRUE)
golem::add_js_file("plop", open = FALSE)
# Should not ask for dircreation
golem::add_js_file("pouet", open = FALSE)

unlink("inst/app/", TRUE)
golem::add_js_handler("plop", open = FALSE)
# Should not ask for dircreation
golem::add_js_handler("pouet", open = FALSE)

setwd(old)
