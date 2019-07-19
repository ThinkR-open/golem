context("tests expect fonctions")

## fake package
fakename <- paste0(sample(letters, 10, TRUE), collapse = "")
tpdir <- tempdir()
if(!dir.exists(file.path(tpdir,fakename))){
  create_golem(file.path(tpdir, fakename), open = FALSE)
}
pkg_expect <- file.path(tpdir, fakename)

test_that("test expect_shinytag",{
  with_dir(pkg_expect,{
    expect_equal(capture_output(expect_shinytag(favicon("jean"))),"")
    expect_error(expect_shinytag("pierre"))
  })
})

test_that("test expect_shinytaglist",{
  with_dir(pkg_expect,{
    expect_equal(capture_output(expect_shinytaglist(shiny::tagList())),"")
    expect_error(expect_shinytaglist('test'))
  })
})

test_that("test expect_shinytaglist",{
  with_dir(pkg_expect,{
    
    ui <- shiny::h1("Jean")
    htmltools::save_html(ui,file = "jean.html")
    expect_equal(capture_output(expect_html_equal(ui = ui,html = "jean.html")),"")
    
  })
})
