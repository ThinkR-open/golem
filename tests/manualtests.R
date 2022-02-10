# old <- setwd(tempdir())
# res <- golem::create_golem(
#   paste0(sample(letters, 10, TRUE), collapse = ""),
#   open = FALSE
# )
# setwd(res)
# unlink("inst/app/", TRUE)
# # Should not ask for dircreation creation
# golem::add_css_file("plop", open = FALSE)
#
# unlink("inst/app/", TRUE)
# golem::add_js_file("plop", open = FALSE, dir_create = FALSE)
# # Should not ask for dircreation
# golem::add_js_file("pouet", open = FALSE)
#
# unlink("inst/app/", TRUE)
# golem::add_js_handler("plop", open = FALSE)
# # Should not ask for dircreation
# golem::add_js_handler("pouet", open = FALSE)
#
# setwd(old)
