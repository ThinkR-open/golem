test_that("test expect_shinytag",{
  with_dir(pkg,{
    expect_equal(capture_output(expect_shinytag(favicon("jean"))),"")
    expect_error(expect_shinytag("pierre"))
  })
})

test_that("test expect_shinytaglist",{
  with_dir(pkg,{
    expect_equal(capture_output(expect_shinytaglist(shiny::tagList())),"")
    expect_error(expect_shinytaglist('test'))
  })
})

test_that("test expect_shinytaglist",{
  with_dir(pkg,{
    ui <- shiny::h1("Jean")
    htmltools::save_html(ui,file = "jean.html")
    expect_equal(capture_output(expect_html_equal(ui = ui,html = "jean.html")),"")
    
  })
})
